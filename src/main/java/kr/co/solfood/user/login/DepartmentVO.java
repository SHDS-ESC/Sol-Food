package kr.co.solfood.user.login;

import lombok.Data;

@Data
public class DepartmentVO {
    private int departmentId; // 부서아이디
    private int companyId; // 회사아이디
    private int departmentCost; // 부서식대
    private String departmentName; // 부서이름
}
