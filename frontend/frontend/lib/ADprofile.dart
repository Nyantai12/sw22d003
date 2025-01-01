import 'package:flutter/material.dart';
import 'package:frontend/sessioin_manager.dart';
import 'package:frontend/login.dart'; // Assuming you have a login page here.

class ProfilePage extends StatelessWidget {
  final String fname;
  final String lname;
  final String uname;

  const ProfilePage({
    required this.fname,
    required this.lname,
    required this.uname,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("First Name: $fname"),
            Text("Last Name: $lname"),
            Text("Email: $uname"),
            ElevatedButton(
              onPressed: () async {
                // Clear user data on logout
                await SessionManager.clearUserData();
                // Navigate to the login page and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false, // This ensures no back navigation
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
