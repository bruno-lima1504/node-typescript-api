# TypeScript Node.js API

API RESTful em Node.js com TypeScript, utilizando o framework Express e MongoDB.

## Recursos

- [Inicialização](#inicialização)
- [Scripts Disponíveis](#scripts-disponíveis)
- [Documentação da API](#documentação-da-api)
- [Testes](#testes)
- [CI/CD](#cicd)
- [Tratamento de Erros](#tratamento-de-erros)
- [Boas Práticas](#boas-práticas)

## Pré-requisitos

- Node.js 24.x
- Yarn
- Docker e Docker Compose

## Inicialização

### Instalação de Dependências

```bash
yarn install
```

### Configuração do Ambiente

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
# Configurações da aplicação
NODE_ENV=development
PORT=3000
MONGO_URL=mongodb://localhost:27017/surf-forecast
JWT_SECRET=your-secret-key
STORM_GLASS_API_KEY=your-storm-glass-key
```

### Executando a Aplicação

**Modo desenvolvimento (com hot-reload):**

```bash
yarn start:dev
```

**Modo produção:**

```bash
yarn start
```

**Usando Docker:**

```bash
# Iniciar todos os serviços (app + MongoDB)
yarn services:run

# Parar os serviços
yarn services:stop

# Remover os serviços
yarn services:down
```

O servidor estará disponível em `http://localhost:3000`

## Scripts Disponíveis

| Script | Descrição |
|--------|-----------|
| `yarn start:dev` | Inicia o servidor em modo desenvolvimento com hot-reload |
| `yarn start` | Compila e inicia o servidor em modo produção |
| `yarn test` | Executa todos os testes (unitários e funcionais) |
| `yarn test:unit` | Executa apenas testes unitários |
| `yarn test:functional` | Executa testes funcionais/E2E |
| `yarn build` | Compila o código TypeScript |
| `yarn services:run` | Inicia os serviços via Docker Compose |
| `yarn services:lint:check` | Verifica linting com ESLint |
| `yarn services:lint:fix` | Corrige problemas de linting |
| `yarn services:prettier:check` | Verifica formatação com Prettier |
| `yarn services:prettier:fix` | Corrige formatação |

## Documentação da API

A documentação interativa da API está disponível em:

```
http://localhost:3000/docs
```

A documentação é gerada automaticamente a partir do schema OpenAPI definido em `src/api.schema.json`.

## Testes

### Testes Unitários

Os testes unitários não requerem conexão com banco de dados e são executados rapidamente.

```bash
yarn test:unit
```

### Testes Funcionais (E2E)

Os testes funcionais requerem o MongoDB rodando. Execute:

```bash
# Inicie o MongoDB de teste
yarn services:db:test

# Execute os testes
yarn test:functional
```

### Todos os Testes

```bash
yarn test
```

## CI/CD

O projeto utiliza GitHub Actions com os seguintes workflows:

### Workflows Disponíveis

1. **Linting** (`.github/workflows/linting.yaml`)
   - Verifica formatação com Prettier
   - Verifica código com ESLint
   - Dispara em pull requests

2. **Testes** (`.github/workflows/tests.yaml`)
   - Executa testes unitários e funcionais
   - Requer MongoDB como serviço
   - Dispara em pull requests

3. **Deploy** (`.github/workflows/deploy.yaml`)
   - Faz deploy automático para a Hostinger ao fazer merge para a branch main
   - Executa build e reinicia os containers Docker

## Tratamento de Erros

A API utiliza uma estrutura padronizada para erros:

```json
{
  "error": "Bad Request",
  "message": "Mensagem de erro detalhada",
  "code": 400,
  "documentation": "URL para documentação opcional"
}
```

### Middleware de Validação

- `src/middlewares/api-error-validator.ts` - trata erros não tratados
- `src/util/errors/api-error.ts` - formata respostas de erro padronizadas
- `src/util/errors/internal-errors.ts` - erros internos customizados

### Códigos de Erro

| Código | Descrição |
|--------|-----------|
| 400 | Bad Request - Requisição inválida |
| 401 | Unauthorized - Não autenticado |
| 404 | Not Found - Recurso não encontrado |
| 409 | Conflict - Conflito de dados |
| 500 | Internal Server Error - Erro interno |

## Boas Práticas

### Logging Estruturado

Utilização do [Pino](https://getpino.io/) para logging estruturado e de alto desempenho:

```typescript
import logger from './logger';
logger.info('Mensagem informativa');
logger.error('Erro occurred', { error });
```

### Conexão com Banco de Dados

- Conexão gerenciada com Mongoose
- Graceful shutdown com fechamento adequado
- Health checks para verificar disponibilidade

### Autenticação e Autorização

- JWT para autenticação stateless
- bcrypt para hashing de senhas
- Middleware de autenticação em rotas protegidas

### Validação de Requisições

- Utilização do `express-openapi-validator` para validação automática
- Schema definido em `api.schema.json`
- Retorna erros 400 automaticamente para requisições inválidas

### Rate Limiting

Proteção contra abuso com `express-rate-limit`:

```typescript
import rateLimit from 'express-rate-limit';
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 100 });
```

### Documentação de Código

JSDoc comments para geração automática de documentação quando necessário.

### Variáveis de Ambiente

- Utilização do pacote `config` para gerenciamento centralizado
- Separação por ambiente (development, production)
- Validação de variáveis obrigatórias

### Graceful Shutdown

Tratamento de sinais do sistema (SIGINT, SIGTERM, SIGQUIT) para encerramento adequado:

```typescript
const exitSignals: NodeJS.Signals[] = ['SIGINT', 'SIGTERM', 'SIGQUIT'];
exitSignals.map((sig) => process.on(sig, async () => { /* cleanup */ }));
```

### Middlewares de Segurança

- CORS configurável
- Rate limiting
- Validação de entrada
- Logging de requisições

### Health Check

Endpoint de verificação de saúde:

```
GET /health
```

Resposta:

```json
{ "status": "ok" }
```

### Estrutura de Projetos

```
src/
├── clients/          # Clientes externos (StormGlass API)
├── controllers/      # Controladores da API
├── middlewares/      # Middlewares Express
├── models/           # Modelos Mongoose
├── services/         # Lógica de negócio
├── util/             # Utilitários
│   └── errors/      # Tratamento de erros
├── logger.ts        # Configuração de logging
└── server.ts       # Configuração do servidor

test/
└── funcional/       # Testes funcionais/E2E
```

## Tech Stack

- **Runtime:** Node.js 24.x
- **Linguagem:** TypeScript
- **Framework:** Express
- **Banco de Dados:** MongoDB com Mongoose
- **Logging:** Pino
- **Validação:** express-openapi-validator
- **Autenticação:** JWT + bcrypt
- **Documentação:** Swagger UI
- **Testes:** Jest + Supertest

## Licença

ISC