import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://127.0.0.1:8000'; // For Android Emulator
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android Emulator
  // static const String baseUrl = 'http://192.168.1.5:8000'; // For physical device or iOS Simulator

  Future<Map<String, dynamic>> getTime() async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'gettime'}),
    );
    return _processResponse(response);
  }
  Future<bool> sendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> getAsuult(Map<String, dynamic> payload) async {
    print("payload");
    print(payload);
    final response = await http.post(
      Uri.parse('$baseUrl/user/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> setHariult(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/index/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    print(payload);
    return _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
