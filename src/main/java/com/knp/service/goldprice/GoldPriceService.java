package com.knp.service.goldprice;

import com.knp.model.dto.goldprice.GoldPriceDTO;
import com.knp.model.dto.goldprice.PriceBoardResponse;

import java.util.List;

public interface GoldPriceService {
    List<GoldPriceDTO> getAllPrices();
    GoldPriceDTO createPrice(GoldPriceDTO dto);
    GoldPriceDTO updatePrice(Long id, GoldPriceDTO dto);
    void deletePrice(Long id);
    PriceBoardResponse getPriceBoard(String code);
    GoldPriceDTO getPriceForCategory(Long categoryId);
}
