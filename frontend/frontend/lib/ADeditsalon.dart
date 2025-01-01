import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSalonPage extends StatefulWidget {
  final String salonid;
  final String currentName;
  final String currentLocation;
  final String currentPhone;

  EditSalonPage({
    required this.salonid,
    required this.currentName,
    required this.currentLocation,
    required this.currentPhone,
  });

  @override
  _EditSalonPageState createState() => _EditSalonPageState();
}

class _EditSalonPageState extends State<EditSalonPage> {
  final _formKey = GlobalKey<FormState>();
  late String _sname;
  late String _slocation;
  late String _sphone;

  @override
  void initState() {
    super.initState();
    _sname = widget.currentName;
    _slocation = widget.currentLocation;
    _sphone = widget.currentPhone;
  }

  Future<void> _editSalon() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/user/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'action': 'edit_salon',
            'salonid': widget.salonid,
            'sname': _sname.isNotEmpty ? _sname : widget.currentName,
            'slocation': _slocation.isNotEmpty ? _slocation : widget.currentLocation,
            'sphone': _sphone.isNotEmpty ? _sphone : widget.currentPhone,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Response Data: $responseData');  // Debugging step

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Salon updated successfully!')),
            );
            Navigator.pop(context, true);

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Failed to update salon')),
            );
          }
        } else {
          throw Exception('Failed to update salon: ${response.reasonPhrase}');
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
        title: Text('Edit Salon'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _sname,
                decoration: InputDecoration(labelText: 'Salon Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the salon name' : null,
                onSaved: (value) => _sname = value!,
              ),
              TextFormField(
                initialValue: _slocation,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the location' : null,
                onSaved: (value) => _slocation = value!,
              ),
              TextFormField(
                initialValue: _sphone,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter the phone number' : null,
                onSaved: (value) => _sphone = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editSalon,
                child: Text('Save Changes'),
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
