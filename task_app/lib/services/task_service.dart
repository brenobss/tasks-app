import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/models/task.dart';

class TaskService {
  static const String _baseUrl = 'http://192.168.15.172:8080/tasks';

  Future<List<Task>> findAllTasks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> tasks = jsonDecode(response.body);
      return tasks.map((item) => Task.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  Future<bool> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toCreateJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> completeTask(Task task) async {
    final completedTask = task.copyWith(status: 'COMPLETED');
    return updateTask(completedTask);
  }
}
