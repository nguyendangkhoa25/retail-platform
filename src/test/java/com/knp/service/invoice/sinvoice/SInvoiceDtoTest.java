package com.knp.service.invoice.sinvoice;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("S-Invoice DTO Tests")
class SInvoiceDtoTest {

    // ── SAccessTokenResponse ──────────────────────────────────────────────────

    @Test
    @DisplayName("SAccessTokenResponse stores all token fields")
    void sAccessTokenResponse_gettersSetters() {
        SAccessTokenResponse token = new SAccessTokenResponse();
        token.setAccessToken("eyJhbGciOiJSUzI1NiJ9.xxx");
        token.setTokenType("Bearer");
        token.setRefreshToken("refresh_token_value");
        token.setExpiresIn(3600);
        token.setScope("read write");
        token.setIssuedAt(1699999999L);
        token.setInvoiceCluster("cluster-1");
        token.setType(1);
        token.setJwtId("jti-uuid");

        assertThat(token.getAccessToken()).isEqualTo("eyJhbGciOiJSUzI1NiJ9.xxx");
        assertThat(token.getTokenType()).isEqualTo("Bearer");
        assertThat(token.getRefreshToken()).isEqualTo("refresh_token_value");
        assertThat(token.getExpiresIn()).isEqualTo(3600);
        assertThat(token.getScope()).isEqualTo("read write");
        assertThat(token.getIssuedAt()).isEqualTo(1699999999L);
        assertThat(token.getInvoiceCluster()).isEqualTo("cluster-1");
        assertThat(token.getType()).isEqualTo(1);
        assertThat(token.getJwtId()).isEqualTo("jti-uuid");
    }

    @Test
    @DisplayName("SAccessTokenResponse equals and hashCode via @Data")
    void sAccessTokenResponse_equalsHashCode() {
        SAccessTokenResponse t1 = new SAccessTokenResponse();
        t1.setAccessToken("token");
        SAccessTokenResponse t2 = new SAccessTokenResponse();
        t2.setAccessToken("token");
        assertThat(t1).isEqualTo(t2);
        assertThat(t1.hashCode()).isEqualTo(t2.hashCode());
    }

    // ── SInvoiceStatusResponse ────────────────────────────────────────────────

    @Test
    @DisplayName("SInvoiceStatusResponse stores response fields")
    void sInvoiceStatusResponse_gettersSetters() {
        SInvoiceStatusResponse.StatusResult result = new SInvoiceStatusResponse.StatusResult();
        result.setSupplierTaxCode("0123456789");
        result.setInvoiceNo("INV-001");
        result.setReservationCode("RES-001");
        result.setIssueDate(1699999999L);
        result.setStatus("ISSUED");
        result.setExchangeStatus("EXCHANGED");
        result.setExchangeDes("Description");
        result.setCodeOfTax("TAX001");

        assertThat(result.getSupplierTaxCode()).isEqualTo("0123456789");
        assertThat(result.getInvoiceNo()).isEqualTo("INV-001");
        assertThat(result.getReservationCode()).isEqualTo("RES-001");
        assertThat(result.getIssueDate()).isEqualTo(1699999999L);
        assertThat(result.getStatus()).isEqualTo("ISSUED");
        assertThat(result.getExchangeStatus()).isEqualTo("EXCHANGED");
        assertThat(result.getExchangeDes()).isEqualTo("Description");
        assertThat(result.getCodeOfTax()).isEqualTo("TAX001");
    }

    @Test
    @DisplayName("SInvoiceStatusResponse stores outer response fields")
    void sInvoiceStatusResponse_outerFields() {
        SInvoiceStatusResponse response = new SInvoiceStatusResponse();
        response.setErrorCode("0");
        response.setDescription("Success");
        response.setTransactionUuid("tx-uuid-abc");
        response.setResult(List.of(new SInvoiceStatusResponse.StatusResult()));

        assertThat(response.getErrorCode()).isEqualTo("0");
        assertThat(response.getDescription()).isEqualTo("Success");
        assertThat(response.getTransactionUuid()).isEqualTo("tx-uuid-abc");
        assertThat(response.getResult()).hasSize(1);
    }

    // ── SInvoiceFileResponse ──────────────────────────────────────────────────

    @Test
    @DisplayName("SInvoiceFileResponse stores download response fields")
    void sInvoiceFileResponse_gettersSetters() {
        SInvoiceFileResponse response = new SInvoiceFileResponse();
        response.setErrorCode(0);
        response.setDescription("OK");
        response.setPaymentStatus(true);
        response.setFileName("invoice.pdf");
        response.setFileToBytes("base64encodedcontent");

        assertThat(response.getErrorCode()).isEqualTo(0);
        assertThat(response.getDescription()).isEqualTo("OK");
        assertThat(response.isPaymentStatus()).isTrue();
        assertThat(response.getFileName()).isEqualTo("invoice.pdf");
        assertThat(response.getFileToBytes()).isEqualTo("base64encodedcontent");
    }

    @Test
    @DisplayName("SInvoiceFileResponse equals and hashCode via @Data")
    void sInvoiceFileResponse_equalsHashCode() {
        SInvoiceFileResponse r1 = new SInvoiceFileResponse();
        r1.setFileName("file.pdf");
        SInvoiceFileResponse r2 = new SInvoiceFileResponse();
        r2.setFileName("file.pdf");
        assertThat(r1).isEqualTo(r2);
    }

    // ── FileInvoiceRequest ────────────────────────────────────────────────────

    @Test
    @DisplayName("FileInvoiceRequest builder creates request with all fields")
    void fileInvoiceRequest_builder() {
        FileInvoiceRequest request = FileInvoiceRequest.builder()
                .supplierTaxCode("0123456789")
                .invoiceNo("INV-001")
                .templateCode("01GTKT")
                .transactionUuid("tx-uuid-def")
                .fileType("pdf")
                .build();

        assertThat(request.getSupplierTaxCode()).isEqualTo("0123456789");
        assertThat(request.getInvoiceNo()).isEqualTo("INV-001");
        assertThat(request.getTemplateCode()).isEqualTo("01GTKT");
        assertThat(request.getTransactionUuid()).isEqualTo("tx-uuid-def");
        assertThat(request.getFileType()).isEqualTo("pdf");
    }

    @Test
    @DisplayName("FileInvoiceRequest supports setters via @Data")
    void fileInvoiceRequest_setters() {
        FileInvoiceRequest request = FileInvoiceRequest.builder().build();
        request.setSupplierTaxCode("9876543210");
        request.setFileType("xml");
        assertThat(request.getSupplierTaxCode()).isEqualTo("9876543210");
        assertThat(request.getFileType()).isEqualTo("xml");
    }

    // ── SInvoiceStatusRequest ─────────────────────────────────────────────────

    @Test
    @DisplayName("SInvoiceStatusRequest builder creates request")
    void sInvoiceStatusRequest_builder() {
        SInvoiceStatusRequest request = SInvoiceStatusRequest.builder()
                .supplierTaxCode("0123456789")
                .transactionUuid("tx-uuid-ghi")
                .build();

        assertThat(request.getSupplierTaxCode()).isEqualTo("0123456789");
        assertThat(request.getTransactionUuid()).isEqualTo("tx-uuid-ghi");
    }

    @Test
    @DisplayName("SInvoiceStatusRequest supports setters via @Data")
    void sInvoiceStatusRequest_setters() {
        SInvoiceStatusRequest request = SInvoiceStatusRequest.builder().build();
        request.setSupplierTaxCode("1234567890");
        request.setTransactionUuid("new-uuid");
        assertThat(request.getSupplierTaxCode()).isEqualTo("1234567890");
        assertThat(request.getTransactionUuid()).isEqualTo("new-uuid");
    }
}
