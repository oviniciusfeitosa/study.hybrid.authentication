package com.example.autenticacaohibrida.security;

import com.example.autenticacaohibrida.model.Usuario;
import com.example.autenticacaohibrida.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.filter.AndFilter;
import org.springframework.ldap.filter.EqualsFilter;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class HybridAuthenticationProvider implements AuthenticationProvider {

    private final LdapTemplate ldapTemplate;
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        // Primeiro tenta autenticar via LDAP (Active Directory)
        try {
            if (authenticateWithLdap(username, password)) {
                // Usuário autenticado via LDAP
                Collection<GrantedAuthority> authorities = new ArrayList<>();
                authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
                
                // Se for admin no LDAP, adiciona a role de admin
                if (isLdapUserAdmin(username)) {
                    authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                }
                
                return new UsernamePasswordAuthenticationToken(username, password, authorities);
            }
        } catch (Exception e) {
            // Se falhar a autenticação LDAP, continua para tentar com o banco de dados
        }

        // Se não autenticou via LDAP, tenta autenticar via banco de dados Oracle
        Usuario usuario = usuarioRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));

        if (!passwordEncoder.matches(password, usuario.getPassword())) {
            throw new BadCredentialsException("Senha inválida");
        }

        // Usuário autenticado via banco de dados
        Collection<GrantedAuthority> authorities = usuario.getPerfis().stream()
                .map(perfil -> new SimpleGrantedAuthority(perfil.getNome()))
                .collect(Collectors.toList());

        return new UsernamePasswordAuthenticationToken(username, password, authorities);
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }

    private boolean authenticateWithLdap(String username, String password) {
        AndFilter filter = new AndFilter();
        filter.and(new EqualsFilter("uid", username));
        
        try {
            return ldapTemplate.authenticate("ou=users", filter.toString(), password);
        } catch (Exception e) {
            return false;
        }
    }
    
    private boolean isLdapUserAdmin(String username) {
        AndFilter filter = new AndFilter();
        filter.and(new EqualsFilter("uid", username));
        
        try {
            List<String> groups = ldapTemplate.search("ou=groups", filter.toString(), 
                (DirContextOperations ctx) -> ctx.getStringAttribute("cn"));
            
            return groups.contains("admins");
        } catch (Exception e) {
            return false;
        }
    }
}
