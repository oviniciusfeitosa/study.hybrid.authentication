package com.example.autenticacaohibrida.controller;

import com.example.autenticacaohibrida.service.TokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class F5AuthController {

    private final TokenService tokenService;

    @PostMapping("/token")
    public ResponseEntity<Map<String, String>> clientCredentialsToken(
            @RequestParam("grant_type") String grantType,
            @RequestParam("client_id") String clientId,
            @RequestParam("client_secret") String clientSecret) {
        
        if (!"client_credentials".equals(grantType)) {
            return ResponseEntity.badRequest().body(Map.of(
                "error", "unsupported_grant_type",
                "error_description", "Apenas grant_type 'client_credentials' é suportado"
            ));
        }
        
        // Validar client_id e client_secret (em produção, isso seria feito de forma mais segura)
        if (!"f5-client".equals(clientId) || !"f5-secret".equals(clientSecret)) {
            return ResponseEntity.status(401).body(Map.of(
                "error", "invalid_client",
                "error_description", "Credenciais de cliente inválidas"
            ));
        }
        
        // Gerar token para o cliente F5
        String token = tokenService.generateToken("f5-system", "ROLE_SYSTEM");
        
        Map<String, String> response = new HashMap<>();
        response.put("token", token);
        response.put("token_type", "Bearer");
        response.put("expires_in", "3600");
        
        return ResponseEntity.ok(response);
    }
}
