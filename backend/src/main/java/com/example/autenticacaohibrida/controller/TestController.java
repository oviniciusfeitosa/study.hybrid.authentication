package com.example.autenticacaohibrida.controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class TestController {

    @GetMapping("/user")
    public Map<String, Object> userInfo(Authentication authentication) {
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("username", authentication.getName());
        userInfo.put("authorities", authentication.getAuthorities());
        userInfo.put("authenticated", authentication.isAuthenticated());
        return userInfo;
    }

    @GetMapping("/admin")
    public Map<String, Object> adminInfo(Authentication authentication) {
        Map<String, Object> adminInfo = new HashMap<>();
        adminInfo.put("message", "Acesso administrativo concedido");
        adminInfo.put("username", authentication.getName());
        adminInfo.put("authorities", authentication.getAuthorities());
        return adminInfo;
    }
}
