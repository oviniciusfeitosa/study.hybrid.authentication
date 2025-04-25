import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loginForm!: FormGroup;
  loading = false;
  submitted = false;
  error = '';
  returnUrl: string = '/home';

  constructor(
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.loginForm = this.formBuilder.group({
      username: ['', Validators.required],
      password: ['', Validators.required]
    });

    // Redirecionar para home se já estiver autenticado
    this.authService.isAuthenticated$.subscribe(isAuthenticated => {
      if (isAuthenticated) {
        this.router.navigate(['/home']);
      }
    });

    // Obter URL de retorno dos parâmetros da rota ou usar padrão
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/home';
  }

  // Getter para fácil acesso aos campos do formulário
  get f() { return this.loginForm.controls; }

  onSubmit(): void {
    this.submitted = true;

    // Parar aqui se o formulário for inválido
    if (this.loginForm.invalid) {
      return;
    }

    this.loading = true;
    this.authService.login(this.f['username'].value, this.f['password'].value)
      .subscribe({
        next: (success) => {
          if (success) {
            this.router.navigate([this.returnUrl]);
          } else {
            this.error = 'Usuário ou senha inválidos';
            this.loading = false;
          }
        },
        error: (error) => {
          this.error = error.error?.message || 'Erro ao tentar fazer login';
          this.loading = false;
        }
      });
  }
}
