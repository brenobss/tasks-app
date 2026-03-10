import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar tarefa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Título",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              decoration: InputDecoration(
                labelText: "Prioridade",
                border: OutlineInputBorder(),
              ),
              items: ['LOW', 'MEDIUM', 'HIGH']
                  .map(
                    (priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateTask();
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future _updateTask() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final taskId = widget.task['id'];

    final success = await _taskService.updateTask(
      _titleController.text,
      _descriptionController.text,
      _selectedPriority,
      widget.task['status'],
      taskId,
      userId,
    );

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao editar tarefa')));
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task['title'] ?? '';
    _descriptionController.text = widget.task['description'] ?? '';
    _selectedPriority = widget.task['priority'] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
