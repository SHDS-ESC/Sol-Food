package kr.co.solfood.admin.login;

import kr.co.solfood.util.CustomException;

public interface AdminLoginService {
    AdminVO login(String password) throws CustomException;
} 