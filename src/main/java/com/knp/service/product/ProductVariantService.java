package com.knp.service.product;

import com.knp.model.dto.product.GenerateVariantsRequest;
import com.knp.model.dto.product.ProductVariantDTO;
import com.knp.model.dto.product.SaveProductVariantRequest;

import java.util.List;

public interface ProductVariantService {

    List<ProductVariantDTO> getVariants(Long productId);

    ProductVariantDTO createVariant(Long productId, SaveProductVariantRequest req);

    ProductVariantDTO updateVariant(Long productId, Long variantId, SaveProductVariantRequest req);

    void deleteVariant(Long productId, Long variantId);

    List<ProductVariantDTO> generateVariants(Long productId, GenerateVariantsRequest req);
}
