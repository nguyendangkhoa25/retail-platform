package com.knp.service.notification;

import com.knp.exception.ResourceNotFoundException;
import com.knp.service.MessageService;
import com.knp.model.dto.notification.CreateNotificationRequest;
import com.knp.model.dto.notification.NotificationDTO;
import com.knp.model.entity.notification.Notification;
import com.knp.model.entity.notification.NotificationPreference;
import com.knp.model.entity.tenant.Tenant;
import com.knp.model.enums.RoleEnum;
import com.knp.multitenant.TenantContext;
import com.knp.repository.notification.NotificationPreferenceRepository;
import com.knp.repository.notification.NotificationRepository;
import com.knp.repository.auth.UserRepository;
import com.knp.repository.tenant.TenantRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final NotificationPreferenceRepository preferenceRepository;
    private final UserRepository userRepository;
    private final TenantRepository tenantRepository;
    private final TenantContext tenantContext;
    private final MessageService messageService;

    public Page<NotificationDTO> getForCurrentUser(Pageable pageable, Notification.NotificationType type) {
        String username = currentUsername();
        Page<Notification> page = (type != null)
                ? notificationRepository.findByUserIdAndType(username, type.name(), pageable)
                : notificationRepository.findByUserId(username, pageable);
        return page.map(this::mapToDTO);
    }

    public long getUnreadCount() {
        return notificationRepository.countUnread(currentUsername());
    }

    @Transactional
    public NotificationDTO markRead(Long id) {
        String username = currentUsername();
        Notification n = notificationRepository.findById(id)
                .filter(x -> !x.isDeleted() && x.getUserId().equals(username))
                .orElseThrow(() -> new ResourceNotFoundException(
                        messageService.getMessage("error.notification.not.found", id)));
        if (!Boolean.TRUE.equals(n.getIsRead())) {
            n.markRead();
            notificationRepository.save(n);
        }
        return mapToDTO(n);
    }

    @Transactional
    public int markAllRead() {
        return notificationRepository.markAllRead(currentUsername());
    }

    @Transactional
    public void delete(Long id) {
        String username = currentUsername();
        Notification n = notificationRepository.findById(id)
                .filter(x -> !x.isDeleted() && x.getUserId().equals(username))
                .orElseThrow(() -> new ResourceNotFoundException(
                        messageService.getMessage("error.notification.not.found", id)));
        n.softDelete();
        notificationRepository.save(n);
    }

    // ── Notification preferences ──────────────────────────────────────────────

    public List<String> getPreferences() {
        return preferenceRepository.findByUserId(currentUsername())
                .map(p -> "ALL".equals(p.getEnabledTypes())
                        ? List.of("ALL")
                        : Arrays.asList(p.getEnabledTypes().split(",")))
                .orElse(List.of("ALL"));
    }

    @Transactional
    public List<String> savePreferences(List<String> enabledTypes) {
        String username = currentUsername();
        NotificationPreference pref = preferenceRepository.findByUserId(username)
                .orElse(NotificationPreference.builder().userId(username).build());
        boolean allEnabled = enabledTypes == null || enabledTypes.isEmpty()
                || enabledTypes.contains("ALL");
        pref.setEnabledTypes(allEnabled ? "ALL" : String.join(",", enabledTypes));
        preferenceRepository.save(pref);
        log.info("Saved notification preferences for {}: {}", username, pref.getEnabledTypes());
        return getPreferences();
    }

    /**
     * Create notifications.
     * If targetUserIds is empty/null, broadcasts to all active users in this tenant.
     */
    @Transactional
    public List<NotificationDTO> create(CreateNotificationRequest req) {
        String creator = currentUsername();
        Notification.NotificationType type = parseType(req.getType());

        List<String> targets = (req.getTargetUserIds() != null && !req.getTargetUserIds().isEmpty())
                ? req.getTargetUserIds()
                : userRepository.findAllActiveUsernames();

        String tenantId = tenantContext.getCurrentTenantId();
        Set<String> optedOut = optedOutUsers(targets, type);
        List<Notification> created = targets.stream()
                .filter(userId -> !optedOut.contains(userId))
                .map(userId -> Notification.builder()
                        .userId(userId)
                        .title(req.getTitle().trim())
                        .message(req.getMessage())
                        .type(type)
                        .referenceType(req.getReferenceType())
                        .referenceId(req.getReferenceId())
                        .isRead(false)
                        .createdBy(creator)
                        .tenantId(tenantId)
                        .build())
                .collect(Collectors.toList());

        List<Notification> saved = notificationRepository.saveAll(created);
        log.info("Created {} notification(s): type={}, title={} ({} opted out)",
                saved.size(), type, req.getTitle(), optedOut.size());
        return saved.stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    // ── Core push API ─────────────────────────────────────────────────────────

    /**
     * Push a notification to all active users holding any of the given roles.
     * TenantContext must be set by the caller when targeting shop-level roles.
     * Respects per-user opt-out preferences.
     */
    @Transactional
    public void pushToRoles(Notification.NotificationType type, String title, String message,
                             String referenceType, Long referenceId, List<String> roleNames) {
        List<String> targets = userRepository.findUsernamesByRoleNames(roleNames);
        if (targets.isEmpty()) {
            log.warn("pushToRoles: no active users found for roles {}", roleNames);
            return;
        }
        String tenantId = tenantContext.getCurrentTenantId();
        Set<String> optedOut = optedOutUsers(targets, type);
        List<Notification> notifications = targets.stream()
                .filter(userId -> !optedOut.contains(userId))
                .map(userId -> Notification.builder()
                        .userId(userId)
                        .title(title)
                        .message(message)
                        .type(type)
                        .referenceType(referenceType)
                        .referenceId(referenceId)
                        .isRead(false)
                        .createdBy("SYSTEM")
                        .tenantId(tenantId)
                        .build())
                .collect(Collectors.toList());
        notificationRepository.saveAll(notifications);
        log.info("pushToRoles: {} notification(s) → roles={} ({} opted out)",
                notifications.size(), roleNames, optedOut.size());
    }

    /**
     * Async fire-and-forget variant of pushToRoles.
     * Pass tenantId when targeting shop-level roles so TenantContext is set on the async thread.
     * Pass null for master-context notifications (MASTER_TENANT, AGENT).
     *
     * NOT_SUPPORTED overrides the class-level readOnly=true so the async thread starts
     * no outer transaction; each repository call inside pushToRoles starts its own
     * writable (or read-only) transaction after TenantContext has already been set.
     */
    @Async
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void pushToRolesAsync(Notification.NotificationType type, String title, String message,
                                  String referenceType, Long referenceId,
                                  List<String> roleNames, String tenantId) {
        try {
            if (tenantId != null) {
                tenantRepository.findByTenantId(tenantId).ifPresent(tenantContext::setCurrentTenant);
            }
            pushToRoles(type, title, message, referenceType, referenceId, roleNames);
        } catch (Exception e) {
            log.warn("Async pushToRoles failed (roles={}, tenantId={}): {}", roleNames, tenantId, e.getMessage(), e);
        } finally {
            if (tenantId != null) {
                tenantContext.clear();
            }
        }
    }

    // ── Specialised push methods (delegate to pushToRoles) ────────────────────

    /**
     * Called by the scheduler (TenantContext already set by caller).
     * Sends a BILLING expiry-warning notification to all SHOP_OWNER users.
     */
    @Transactional
    public void pushExpiryWarning(Tenant tenant, int daysRemaining) {
        Locale vi = new Locale("vi");
        String expiryDate = tenant.getExpirationDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        String title = messageService.getMessage("notification.expiry.warning.title", vi, daysRemaining);
        String message = messageService.getMessage("notification.expiry.warning.message", vi,
                tenant.getName(), expiryDate);
        pushToRoles(Notification.NotificationType.BILLING, title, message,
                "TENANT", tenant.getId(), List.of(RoleEnum.SHOP_OWNER.getCode()));
    }

    /**
     * Broadcast a SYSTEM notification to all active MASTER_TENANT users.
     */
    @Transactional
    public void pushToMasterUsers(String title, String message, String referenceType, Long referenceId) {
        pushToRoles(Notification.NotificationType.SYSTEM, title, message,
                referenceType, referenceId, List.of("MASTER_TENANT"));
    }

    /**
     * Async fire-and-forget variant of pushToMasterUsers.
     */
    @Async
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void pushToMasterUsersAsync(String title, String message, String referenceType, Long referenceId) {
        try {
            pushToRoles(Notification.NotificationType.SYSTEM, title, message,
                    referenceType, referenceId, List.of("MASTER_TENANT"));
        } catch (Exception e) {
            log.warn("Async pushToMasterUsers failed: {}", e.getMessage(), e);
        }
    }

    /**
     * Push a notification to a single user. Type is explicit so callers can use SYSTEM, BILLING, etc.
     */
    @Transactional
    public void pushSystem(String userId, Notification.NotificationType type, String title, String message,
                           String referenceType, Long referenceId) {
        Notification n = Notification.builder()
                .userId(userId)
                .title(title)
                .message(message)
                .type(type)
                .referenceType(referenceType)
                .referenceId(referenceId)
                .isRead(false)
                .createdBy("SYSTEM")
                .tenantId(tenantContext.getCurrentTenantId())
                .build();
        notificationRepository.save(n);
    }

    /**
     * Async fire-and-forget variant of pushSystem targeting a single known user.
     * Pass tenantId when the user belongs to a shop tenant; null for master context.
     */
    @Async
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void pushSystemAsync(String userId, Notification.NotificationType type,
                                String title, String message,
                                String referenceType, Long referenceId, String tenantId) {
        try {
            if (tenantId != null) {
                tenantRepository.findByTenantId(tenantId).ifPresent(tenantContext::setCurrentTenant);
            }
            pushSystem(userId, type, title, message, referenceType, referenceId);
        } catch (Exception e) {
            log.warn("Async pushSystem failed (userId={}, tenantId={}): {}", userId, tenantId, e.getMessage(), e);
        } finally {
            if (tenantId != null) {
                tenantContext.clear();
            }
        }
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    /**
     * Returns user IDs from the given list who have opted out of the specified type.
     * Single batch query — avoids N+1.
     */
    private Set<String> optedOutUsers(List<String> userIds, Notification.NotificationType type) {
        return preferenceRepository.findByUserIdIn(userIds).stream()
                .filter(p -> !"ALL".equals(p.getEnabledTypes())
                        && !Arrays.asList(p.getEnabledTypes().split(",")).contains(type.name()))
                .map(NotificationPreference::getUserId)
                .collect(Collectors.toSet());
    }

    private String currentUsername() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    private Notification.NotificationType parseType(String raw) {
        if (raw == null) return Notification.NotificationType.INFO;
        try {
            return Notification.NotificationType.valueOf(raw.toUpperCase());
        } catch (IllegalArgumentException e) {
            return Notification.NotificationType.INFO;
        }
    }

    private NotificationDTO mapToDTO(Notification n) {
        return NotificationDTO.builder()
                .id(n.getId())
                .userId(n.getUserId())
                .title(n.getTitle())
                .message(n.getMessage())
                .type(n.getType().name())
                .referenceType(n.getReferenceType())
                .referenceId(n.getReferenceId())
                .isRead(n.getIsRead())
                .readAt(n.getReadAt())
                .createdBy(n.getCreatedBy())
                .createdAt(n.getCreatedAt())
                .build();
    }
}
