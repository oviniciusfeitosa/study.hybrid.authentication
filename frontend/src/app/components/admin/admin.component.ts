import { Component, OnInit } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})
export class AdminComponent implements OnInit {
  adminInfo: any = {};
  loading = true;
  error = '';

  constructor(
    private authService: AuthService,
    private http: HttpClient
  ) { }

  ngOnInit(): void {
    this.http.get<any>('/api/admin').subscribe({
      next: (data) => {
        this.adminInfo = data;
        this.loading = false;
      },
      error: (error) => {
        this.error = error.error?.message || 'Erro ao carregar informações de administrador';
        this.loading = false;
      }
    });
  }

  logout(): void {
    this.authService.logout();
  }
}
