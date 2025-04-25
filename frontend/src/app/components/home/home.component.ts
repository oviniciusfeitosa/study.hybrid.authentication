import { Component, OnInit } from '@angular/core';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  userInfo: any = {};
  loading = true;
  error = '';

  constructor(private authService: AuthService) { }

  ngOnInit(): void {
    // Aqui poderia ser feita uma chamada para obter informações do usuário
    // Por simplicidade, vamos apenas verificar se o usuário está autenticado
    this.authService.isAuthenticated$.subscribe(
      isAuthenticated => {
        this.loading = false;
        if (!isAuthenticated) {
          this.error = 'Usuário não autenticado';
        }
      }
    );
  }

  logout(): void {
    this.authService.logout();
  }
}
