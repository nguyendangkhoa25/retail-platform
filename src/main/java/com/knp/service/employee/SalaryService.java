package com.knp.service.employee;

import com.knp.model.dto.employee.ApproveSalaryRequest;
import com.knp.model.dto.employee.GenerateSalaryRequest;
import com.knp.model.dto.employee.SalaryAdjustmentDTO;
import com.knp.model.dto.employee.SalaryAdjustmentRequest;
import com.knp.model.dto.employee.SalaryDTO;
import org.springframework.data.domain.Page;

import java.util.List;

public interface SalaryService {
    List<SalaryDTO> generatePayroll(GenerateSalaryRequest request);
    Page<SalaryDTO> getSalaries(String status, Integer year, Integer month, int page, int size);
    SalaryDTO getSalaryDetail(Long id);
    SalaryDTO approve(Long id, ApproveSalaryRequest request);
    SalaryDTO markPaid(Long id);
    void delete(Long id);
    SalaryAdjustmentDTO addAdjustment(Long salaryId, SalaryAdjustmentRequest req);
    void removeAdjustment(Long salaryId, Long adjId);
}
