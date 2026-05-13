package com.tappy.pos.controller.mobile;

import com.tappy.pos.model.dto.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/subscriptions")
public class SubscriptionController {

    @GetMapping("/current")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCurrent() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("plan", "BASIC");
        data.put("status", "ACTIVE");
        data.put("startedAt", LocalDate.now().minusYears(1).toString());
        data.put("expiresAt", LocalDate.now().plusYears(1).toString());
        data.put("maxUsers", 10);
        data.put("currentUsers", 1);
        data.put("features", List.of());
        return ResponseEntity.ok(ApiResponse.success(data, "OK"));
    }
}
