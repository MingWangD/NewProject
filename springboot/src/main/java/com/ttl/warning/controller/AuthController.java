package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.dto.LoginRequest;
import com.ttl.warning.entity.User;
import com.ttl.warning.service.AuthService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ApiResponse<User> login(@RequestBody LoginRequest request) {
        User user = authService.login(request);
        if (user == null) return ApiResponse.fail("用户名或密码错误");
        user.setPassword(null);
        return ApiResponse.ok(user);
    }
}
