# 📝 Tasks App

Aplicação de gerenciamento de tarefas com autenticação, desenvolvida com Flutter no frontend e Spring Boot no backend.

## 🚀 Tecnologias

- **Frontend:** Flutter
- **Backend:** Java 23 + Spring Boot 4.0.3
- **Banco de dados:** H2 (desenvolvimento)

## 📱 Funcionalidades

- [X] CRUD de usuários
- [X] CRUD de tarefas
- [ ] Marcar tarefa como concluída
- [ ] Filtrar tarefas por status
- [ ] Autenticação
- [ ] DTOs
- [ ] Validações
- [ ] Telas Flutter

## 🗂️ Estrutura do Repositório
```
tasks-app/
├── task_app/   # Aplicação Flutter
└── tasks_api/        # API Spring Boot
```

## ⚙️ Como rodar localmente

### Backend
```bash
cd tasks_api
./mvnw spring-boot:run
```

### Frontend
```bash
cd task_app
flutter pub get
flutter run
```

## 🔗 Rotas da API

### Usuários

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | /users | Lista todos os usuários |
| GET | /users/{id} | Busca usuário por id |
| POST | /users | Cria usuário |
| PUT | /users/{id} | Atualiza usuário |
| DELETE | /users/{id} | Remove usuário |

### Tarefas

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | /tasks | Lista todas as tarefas |
| GET | /tasks/{id} | Busca tarefa por id |
| POST | /tasks | Cria tarefa |
| PUT | /tasks/{id} | Atualiza tarefa |
| DELETE | /tasks/{id} | Remove tarefa |

## 📦 Exemplos de requisição

### Criar usuário
```json
{
  "name": "Breno Santos",
  "email": "breno@email.com",
  "password": "123456"
}
```

### Criar tarefa
```json
{
  "title": "Estudar Flutter",
  "description": "Praticar widgets básicos",
  "priority": "MEDIUM",
  "user": { "id": 1 }
}
```


## 👨‍💻 Autor

Feito por [Breno](https://github.com/brenobss)