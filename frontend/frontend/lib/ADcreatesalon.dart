import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateSalonPage extends StatefulWidget {
  @override
  _CreateSalonPageState createState() => _CreateSalonPageState();
}

class _CreateSalonPageState extends State<CreateSalonPage> {
  final _formKey = GlobalKey<FormState>();
  String _sname = '';
  String _slocation = '';
  String _sphone = '';

  Future<void> _createSalon() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/user/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'action': 'create_salon',
            'sname': _sname,
            'slocation': _slocation,
            'sphone': _sphone,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Salon created successfully!')),
          );
          Navigator.pop(context, true); // Return to the previous screen
        } else {
          throw Exception('Failed to create salon');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Salon'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Salon Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the salon name'
                    : null,
                onSaved: (value) => _sname = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the location'
                    : null,
                onSaved: (value) => _slocation = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the phone number'
                    : null,
                onSaved: (value) => _sphone = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createSalon,
                child: Text('Create Salon'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
