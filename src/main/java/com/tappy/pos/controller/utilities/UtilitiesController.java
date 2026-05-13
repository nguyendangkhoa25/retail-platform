package com.tappy.pos.controller.utilities;

import com.tappy.pos.model.dto.ApiResponse;
import com.tappy.pos.model.dto.exchangerate.ExchangeRateResponse;
import com.tappy.pos.service.exchangerate.ExchangeRateService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/utilities")
@RequiredArgsConstructor
public class UtilitiesController {

    private final ExchangeRateService exchangeRateService;

    @GetMapping("/exchange-rates")
    public ResponseEntity<ApiResponse<ExchangeRateResponse>> getExchangeRates() {
        log.info("Endpoint: GET /utilities/exchange-rates");
        ExchangeRateResponse data = exchangeRateService.getLatest();
        if (data.rates().isEmpty()) {
            return ResponseEntity.status(503)
                    .body(ApiResponse.error("Exchange rate data not yet available"));
        }
        return ResponseEntity.ok(ApiResponse.success(data, "OK"));
    }
}
