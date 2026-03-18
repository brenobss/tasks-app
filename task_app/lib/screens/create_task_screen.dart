import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/services/task_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _taskService = TaskService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'MEDIUM';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createTask() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _selectedPriority,
      userId: userId,
    );

    final success = await _taskService.createTask(task);

    if (success) {
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao criar tarefa')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Tarefa',
          style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TÍTULO', style: _labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Ex: Estudar Flutter',
                ),
              ),
              const SizedBox(height: 24),
              const Text('DESCRIÇÃO', style: _labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Adicione detalhes da tarefa...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              const Text('PRIORIDADE', style: _labelStyle),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPriorityButton('LOW', 'Baixa'),
                  const SizedBox(width: 12),
                  _buildPriorityButton('MEDIUM', 'Média'),
                  const SizedBox(width: 12),
                  _buildPriorityButton('HIGH', 'Alta'),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity, // Faz o botão ocupar toda a largura
                child: ElevatedButton(
                  onPressed: _createTask,
                  child: const Text('Criar tarefa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String value, String label) {
    final isSelected = _selectedPriority == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : const Color(0xFF2A2A2A),
            border: Border.all(
              color: isSelected ? const Color(0xFFCCFF00) : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFCCFF00)
                  : const Color(0xFFAAAAAA),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// Constante de estilo igual à da tela de edição
const _labelStyle = TextStyle(
  fontSize: 11,
  letterSpacing: 1.5,
  color: Color(0xFFAAAAAA),
);
