package com.example.autenticacaohibrida.controller;

import com.example.autenticacaohibrida.model.AuthRequest;
import com.example.autenticacaohibrida.model.AuthResponse;
import com.example.autenticacaohibrida.service.TokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final TokenService tokenService;

    @PostMapping("/token")
    public ResponseEntity<AuthResponse> token(@RequestBody AuthRequest request) {
        String token = tokenService.generateToken(request.getUsername(), request.getPassword());
        return ResponseEntity.ok(new AuthResponse(token));
    }
}
