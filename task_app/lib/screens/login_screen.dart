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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFCCFF00),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Organize seu dia com clareza',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'E-MAIL',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 20),
              const Text(
                'SENHA',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _login(),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {}, // navegação para cadastro — faremos a seguir
                  child: RichText(
                    text: const TextSpan(
                      text: 'Não tem conta? ',
                      style: TextStyle(color: Color(0xFFAAAAAA)),
                      children: [
                        TextSpan(
                          text: 'Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFFCCFF00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    final success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskListScreen()),
      );
    else
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou senha incorretos')),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
