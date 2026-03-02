import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<bool> login(String email, String password) async {
    final response = await http.get(
      Uri.parse('http://192.168.15.172:8080/users'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );
      return user != null;
    } else {
      return false;
    }
  }
}
