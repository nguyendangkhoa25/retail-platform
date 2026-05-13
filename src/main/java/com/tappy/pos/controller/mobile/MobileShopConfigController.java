package com.tappy.pos.controller.mobile;

import com.tappy.pos.annotation.RequiresFeature;
import com.tappy.pos.model.dto.ApiResponse;
import com.tappy.pos.model.dto.bank.BankAccountDTO;
import com.tappy.pos.model.dto.tenant.MobileShopInfoDTO;
import com.tappy.pos.model.dto.tenant.ShopInfoDTO;
import com.tappy.pos.model.enums.ShopType;
import com.tappy.pos.multitenant.TenantContext;
import com.tappy.pos.service.finance.BankAccountService;
import com.tappy.pos.service.tenant.ShopInfoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/shop-config")
@RequiredArgsConstructor
public class MobileShopConfigController {

    private final BankAccountService bankAccountService;
    private final ShopInfoService shopInfoService;
    private final TenantContext tenantContext;

    @GetMapping
    @RequiresFeature("SHOP_INFO")
    public ResponseEntity<ApiResponse<MobileShopInfoDTO>> getShopConfig() {
        log.info("Endpoint: GET /shop-config");
        ShopInfoDTO shopInfo = shopInfoService.getShopInfo();
        String shopTypeCode = Optional.ofNullable(tenantContext.getCurrentTenant())
                .map(t -> t.getShopType())
                .map(ShopType::name)
                .orElse(null);

        MobileShopInfoDTO dto = MobileShopInfoDTO.builder()
                .shopName(shopInfo.getShopName())
                .address(shopInfo.getAddress())
                .phone(shopInfo.getPhone())
                .description(null)
                .logoUrl(null)
                .shopTypeCode(shopTypeCode)
                .posMode(shopInfo.getPosMode())
                .build();

        return ResponseEntity.ok(ApiResponse.success(dto, "OK"));
    }

    @GetMapping("/banks")
    @RequiresFeature("BANK_ACCOUNT")
    public ResponseEntity<ApiResponse<List<BankAccountDTO>>> getBanks() {
        log.info("Endpoint: GET /shop-config/banks");
        return ResponseEntity.ok(ApiResponse.success(bankAccountService.getAll(), "OK"));
    }

    @GetMapping("/loyalty")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getLoyalty() {
        log.info("Endpoint: GET /shop-config/loyalty");
        return ResponseEntity.ok(ApiResponse.success(
                Map.of("enabled", false, "pointsPerUnit", 1, "minimumRedeemPoints", 100),
                "OK"));
    }
}
