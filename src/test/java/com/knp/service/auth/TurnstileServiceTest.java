package com.knp.service.auth;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TurnstileService Unit Tests")
class TurnstileServiceTest {

    // ── disabled mode ─────────────────────────────────────────────────────────

    @Test
    @DisplayName("verify: returns true immediately when disabled")
    void verify_disabled() {
        TurnstileService service = new TurnstileService();
        ReflectionTestUtils.setField(service, "enabled", false);
        ReflectionTestUtils.setField(service, "secretKey", "dummy-secret");

        assertThat(service.verify("any-token", "1.2.3.4")).isTrue();
    }

    @Test
    @DisplayName("verify: returns false for null token when enabled")
    void verify_nullToken() {
        TurnstileService service = new TurnstileService();
        ReflectionTestUtils.setField(service, "enabled", true);
        ReflectionTestUtils.setField(service, "secretKey", "dummy-secret");

        assertThat(service.verify(null, "1.2.3.4")).isFalse();
    }

    @Test
    @DisplayName("verify: returns false for blank token when enabled")
    void verify_blankToken() {
        TurnstileService service = new TurnstileService();
        ReflectionTestUtils.setField(service, "enabled", true);
        ReflectionTestUtils.setField(service, "secretKey", "dummy-secret");

        assertThat(service.verify("   ", "1.2.3.4")).isFalse();
    }

    @Test
    @DisplayName("verify: returns false when HTTP call fails (no real network)")
    void verify_networkError() {
        TurnstileService service = new TurnstileService();
        ReflectionTestUtils.setField(service, "enabled", true);
        ReflectionTestUtils.setField(service, "secretKey", "test-secret");

        // Will fail with a network error — service catches it and returns false
        boolean result = service.verify("test-token", "127.0.0.1");

        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("verify: null clientIp omits remoteip field and still returns false on network error")
    void verify_nullClientIp() {
        TurnstileService service = new TurnstileService();
        ReflectionTestUtils.setField(service, "enabled", true);
        ReflectionTestUtils.setField(service, "secretKey", "test-secret");

        boolean result = service.verify("test-token", null);

        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("verify: blank clientIp omits remoteip field and still returns false on network error")
    void verify_blankClientIp() {
        TurnstileService service = new TurnstileService();
        ReflectionTestUtils.setField(service, "enabled", true);
        ReflectionTestUtils.setField(service, "secretKey", "test-secret");

        boolean result = service.verify("test-token", "   ");

        assertThat(result).isFalse();
    }
}
