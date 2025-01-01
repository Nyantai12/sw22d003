import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/adminhomepage.dart';
import 'package:frontend/homepage.dart';
import 'package:frontend/sessioin_manager.dart';
import 'package:http/http.dart' as http;

import 'ADprofile.dart';

Future<void> login(BuildContext context, String email, String password) async {
  final url = Uri.parse("http://10.0.2.2:8000/user/"); // Replace with your API URL
  final body = jsonEncode({
    "action": "login",
    "uname": email,
    "upassword": password,
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
      if (data["resultCode"] == 1002) {
        print("Login Successful: ${data['resultMessage']}");

        final userData = data["data"][0];
        print("Welcome ${userData['fname']} ${userData['lname']}");

        String uid = userData["uid"].toString();  // Ensure UID is a String
        int role = userData["role"];             // Role field

        // Save UID and user data to SessionManager
        await SessionManager.saveUid(uid);
        await SessionManager.saveUserData({
          "fname": userData['fname'],
          "lname": userData['lname'],
          "uname": userData['uname'],
        });

        // Navigate based on role
        if (role == 1) {
          // Admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomHomePage1()),
          );
        } else {
          // Regular User
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomHomePage()),
          );
        }

      } else {
        print("Login Failed: ${data['resultMessage']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: ${data['resultMessage']}")),
        );
      }
    } else {
      print("Error: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server Error: ${response.statusCode}")),
      );
    }
  } catch (e) {
    print("An error occurred: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred. Please try again.")),
    );
  }
}



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out all fields.")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Call login method
    await login(context, email, password);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
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
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _handleLogin,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
