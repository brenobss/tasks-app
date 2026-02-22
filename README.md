# 📝 Tasks App

Aplicação de gerenciamento de tarefas com autenticação, desenvolvida com Flutter no frontend e Spring Boot no backend.

## 🚀 Tecnologias

- **Frontend:** Flutter
- **Backend:** Java + Spring Boot
- **Banco de dados:** H2 (desenvolvimento)

## 📱 Funcionalidades

- [ ] Cadastro e login de usuário
- [ ] Criar, listar, editar e excluir tarefas
- [ ] Marcar tarefa como concluída
- [ ] Filtrar tarefas por status

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

## 👨‍💻 Autor

Feito por [Breno](https://github.com/brenobss)