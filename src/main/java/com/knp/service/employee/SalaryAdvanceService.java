package com.knp.service.employee;

import com.knp.model.dto.employee.CreateAdvanceRequest;
import com.knp.model.dto.employee.SalaryAdvanceDTO;
import org.springframework.data.domain.Page;

public interface SalaryAdvanceService {
    SalaryAdvanceDTO createAdvance(CreateAdvanceRequest req);
    Page<SalaryAdvanceDTO> getAdvances(Long employeeId, int page, int size);
    void deleteAdvance(Long id);
}
