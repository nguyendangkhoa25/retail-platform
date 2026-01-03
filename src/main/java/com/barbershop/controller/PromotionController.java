package com.barbershop.controller;

import com.barbershop.model.dto.promotion.CreatePromotionRequest;
import com.barbershop.model.dto.promotion.PromotionDTO;
import com.barbershop.service.PromotionService;
import com.barbershop.model.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/promotions")
@RequiredArgsConstructor
public class PromotionController {

    private final PromotionService promotionService;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<PromotionDTO>>> getAllPromotions(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "100") int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<PromotionDTO> promotions = promotionService.getAllPromotions(pageable);
        return ResponseEntity.ok(ApiResponse.success(promotions, "Promotions retrieved successfully"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PromotionDTO>> getPromotionById(@PathVariable Long id) {
        PromotionDTO promotion = promotionService.getPromotionById(id);
        return ResponseEntity.ok(ApiResponse.success(promotion, "Promotion retrieved successfully"));
    }

    @GetMapping("/active/combo")
    public ResponseEntity<ApiResponse<List<PromotionDTO>>> getActiveComboPromotions() {
        List<PromotionDTO> promotions = promotionService.getActiveComboPromotions();
        return ResponseEntity.ok(ApiResponse.success(promotions, "Active combo promotions retrieved successfully"));
    }

    @GetMapping("/active/time-based")
    public ResponseEntity<ApiResponse<List<PromotionDTO>>> getActiveTimeBasedPromotions() {
        List<PromotionDTO> promotions = promotionService.getActiveTimeBasedPromotions();
        return ResponseEntity.ok(ApiResponse.success(promotions, "Active time-based promotions retrieved successfully"));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<PromotionDTO>> createPromotion(@RequestBody CreatePromotionRequest request) {
        PromotionDTO promotion = promotionService.createPromotion(request);
        return ResponseEntity.ok(ApiResponse.success(promotion, "Promotion created successfully"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<PromotionDTO>> updatePromotion(
            @PathVariable Long id,
            @RequestBody CreatePromotionRequest request) {
        PromotionDTO promotion = promotionService.updatePromotion(id, request);
        return ResponseEntity.ok(ApiResponse.success(promotion, "Promotion updated successfully"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deletePromotion(@PathVariable Long id) {
        promotionService.deletePromotion(id);
        return ResponseEntity.ok(ApiResponse.<Void>success(null, "Promotion deleted successfully"));
    }
}

