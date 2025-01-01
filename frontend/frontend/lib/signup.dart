import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:frontend/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> signup(
    String email, String password, String firstName, String lastName, BuildContext context) async {
  final url = Uri.parse("http://10.0.2.2:8000/user/");

  // Hash the password using MD5
  final hashedPassword = md5.convert(utf8.encode(password)).toString();

  // Django API endpoint
  final body = jsonEncode({
    "action": "register",
    "uname": email,
    "upassword": hashedPassword,
    "lname": lastName,
    "fname": firstName,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resultCode'] == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Амжилттай бүртгэгдлээ"),
              content: Text("Та бүртгүүлсэн MAIL-ээ шалгаж баталгаажуулалт хийнэ үү !"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        print("Error: ${data['resultMessage']}");
      }
    } else {
      final errorData = jsonDecode(response.body);
      print("Error: ${errorData['resultMessage']}");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: "Last Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final password = _passwordController.text;
                final firstName = _firstNameController.text;
                final lastName = _lastNameController.text;

                signup(email, password, firstName, lastName, context);
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
