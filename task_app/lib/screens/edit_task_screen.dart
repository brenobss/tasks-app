import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _taskService = TaskService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'MEDIUM';

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _selectedPriority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future _updateTask() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _selectedPriority,
      status: widget.task.status,
      userId: userId,
      createdAt: widget.task.createdAt,
    );

    final success = await _taskService.updateTask(updatedTask);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao editar tarefa')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar tarefa",
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
                  hintText: 'Ex: Estudar programação',
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
                  const SizedBox(width: 12), // Corrigido de height para width
                  _buildPriorityButton('MEDIUM', 'Média'),
                  const SizedBox(width: 12), // Corrigido de height para width
                  _buildPriorityButton('HIGH', 'Alta'),
                ],
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => _updateTask(),
                child: const Text('Salvar alterações'),
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

const _labelStyle = TextStyle(
  fontSize: 11,
  letterSpacing: 1.5,
  color: Color(0xFFAAAAAA),
);
