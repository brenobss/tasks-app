import 'package:flutter/material.dart';
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
  List<dynamic> _tasks = [];
  bool _isLoading = true;

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
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['status']),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(task: task),
                      ),
                    );
                    _loadTasks();
                  },
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

  void _loadTasks() async {
    final tasks = await _taskService.findAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
}
