import 'package:flutter/material.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/screens/create_task_screen.dart';
import 'package:task_app/screens/edit_task_screen.dart';
import 'package:task_app/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await _taskService.findAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  void _completeTask(Task task) async {
    final success = await _taskService.completeTask(task);
    if (success) {
      setState(() {
        final index = _tasks.indexOf(task);
        _tasks[index] = task.copyWith(status: 'COMPLETED');
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao concluir tarefa')));
    }
  }

  void _deleteTask(Task task) async {
    final success = await _taskService.deleteTask(task.id!);
    if (!success) {
      _loadTasks();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao deletar tarefa')));
    }
  }

  void _uncompleteTask(Task task) async {
    final success = await _taskService.uncompleteTask(task);
    if (success) {
      setState(() {
        final index = _tasks.indexOf(task);
        _tasks[index] = task.copyWith(status: 'PENDING');
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao desmarcar tarefa')));
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Deletar tarefa"),
            content: const Text("Tem certeza que deseja deletar essa tarefa?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key(task.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await _showDeleteConfirmation();
                  },
                  onDismissed: (_) => _deleteTask(task),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(task.status),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: task.isCompleted
                          ? (_) => _uncompleteTask(task)
                          : (_) => _completeTask(task),
                    ),
                    onTap: task.isCompleted
                        ? null
                        : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditTaskScreen(task: task),
                              ),
                            );
                            _loadTasks();
                          },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
          _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
