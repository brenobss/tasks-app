import 'dart:convert';

import 'package:http/http.dart' as http;

class TaskService {
  Future<List<dynamic>> findAllTasks() async {
    final response = await http.get(
      Uri.parse('http://192.168.15.172:8080/tasks'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> tasks = jsonDecode(response.body);
      return tasks;
    } else {
      return [];
    }
  }

  Future<bool> createTask(
    String title,
    String description,
    String priority,
    int userId,
  ) async {
    final body = jsonEncode({
      'title': title,
      'description': description,
      'priority': priority,
      'user': {'id': userId},
    });
    final response = await http.post(
      Uri.parse('http://192.168.15.172:8080/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTask(
    String title,
    String description,
    String priority,
    String status,
    int taskId,
    int userId,
  ) async {
    final body = jsonEncode({
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'user': {'id': userId},
    });
    final response = await http.put(
      Uri.parse('http://192.168.15.172:8080/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
