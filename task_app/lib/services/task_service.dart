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
}
