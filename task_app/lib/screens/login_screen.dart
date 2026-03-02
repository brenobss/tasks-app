import 'package:flutter/material.dart';
import 'package:task_app/screens/task_list_screen.dart';
import '../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Logo"),
              SizedBox(width: 16),
              Text('Tasks'),
              Text("Organize seu dia com clareza"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _login();
                },
                child: Text('Entrar'),
              ),
              Text(
                "Esqueci minha senha",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              Text(
                "Novo por aqui? Cadastre-se",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _login() async {
    final success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskListScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email ou senha incorretos')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
