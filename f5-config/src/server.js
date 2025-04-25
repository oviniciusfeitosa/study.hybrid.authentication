const express = require('express');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');

// Carregar variáveis de ambiente
dotenv.config();

const app = express();
const PORT = process.env.PORT || 8090;
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend:8080';

// Configuração de middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Configuração do cliente OAuth2
const clientId = 'f5-client';
const clientSecret = 'f5-secret';

// Rota principal para simular o F5 como proxy
app.all('*', async (req, res) => {
  try {
    // Verificar se já existe um token válido no header
    const authHeader = req.headers.authorization;
    
    if (authHeader && authHeader.startsWith('Bearer ')) {
      // Encaminhar a requisição para o backend com o token existente
      const response = await forwardRequestToBackend(req);
      return sendResponse(res, response);
    }
    
    // Se não tiver token, tentar obter um novo usando client_credentials
    const token = await getOAuthToken();
    
    if (!token) {
      return res.status(401).json({ 
        error: 'unauthorized', 
        error_description: 'Não foi possível obter um token de acesso' 
      });
    }
    
    // Adicionar o token ao header e encaminhar a requisição
    req.headers.authorization = `Bearer ${token}`;
    const response = await forwardRequestToBackend(req);
    
    return sendResponse(res, response);
  } catch (error) {
    console.error('Erro no proxy F5:', error.message);
    
    // Se o erro vier do backend, retornar a resposta original
    if (error.response) {
      return sendResponse(res, error.response);
    }
    
    // Caso contrário, retornar erro interno
    return res.status(500).json({ 
      error: 'internal_server_error',
      error_description: 'Erro interno no servidor F5'
    });
  }
});

// Função para obter token OAuth2 usando client_credentials
async function getOAuthToken() {
  try {
    const response = await axios.post(`${BACKEND_URL}/api/auth/token`, {
      grant_type: 'client_credentials',
      client_id: clientId,
      client_secret: clientSecret
    });
    
    return response.data.token;
  } catch (error) {
    console.error('Erro ao obter token OAuth2:', error.message);
    return null;
  }
}

// Função para encaminhar a requisição para o backend
async function forwardRequestToBackend(req) {
  const url = `${BACKEND_URL}${req.url}`;
  const method = req.method.toLowerCase();
  const headers = { ...req.headers };
  const data = req.body;
  
  // Remover headers específicos do Express que podem causar problemas
  delete headers.host;
  
  return await axios({
    method,
    url,
    headers,
    data: method !== 'get' ? data : undefined,
    params: method === 'get' ? data : undefined
  });
}

// Função para enviar a resposta do backend para o cliente
function sendResponse(res, backendResponse) {
  res.status(backendResponse.status);
  
  // Copiar headers da resposta do backend
  Object.entries(backendResponse.headers).forEach(([key, value]) => {
    // Ignorar headers específicos que podem causar problemas
    if (!['transfer-encoding', 'connection'].includes(key.toLowerCase())) {
      res.set(key, value);
    }
  });
  
  return res.send(backendResponse.data);
}

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Simulador F5 com OAuth2 rodando na porta ${PORT}`);
  console.log(`Conectado ao backend em ${BACKEND_URL}`);
});
