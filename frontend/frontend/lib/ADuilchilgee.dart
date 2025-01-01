import 'package:flutter/material.dart';
import 'package:frontend/editsalon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ADSalonDetPage.dart';
import 'ADcreatesalon.dart';
import 'ADeditsalon.dart';

class UilchilgeePage1 extends StatefulWidget {
  @override
  _UilchilgeePageState createState() => _UilchilgeePageState();
}

class _UilchilgeePageState extends State<UilchilgeePage1> {
  List<SalonCard> salons = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSalons();
  }

  // Fetch salons from API
  Future<void> _fetchSalons() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'get_salon'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Response data: $data');  // Debugging step to check the structure

        final List<dynamic> salonsData = data['data']['salons'] ?? [];

        if (salonsData.isNotEmpty) {
          final List<SalonCard> salonList = salonsData.map((json) {
            return SalonCard.fromJson(json);
          }).toList();

          setState(() {
            salons = salonList;
          });
        } else {
          setState(() {
            errorMessage = 'No salons found.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch salons. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching salons: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Үйлчилгээ'),
        backgroundColor: Colors.pink,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: salons.length,
        itemBuilder: (context, index) {
          final salon = salons[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ADSalonDetPage1(
                    salonid: salon.salonid,

                  ),
                ),
              );
            },
            child: SalonCard(
              salonid: salon.salonid,
              name: salon.name,
              location: salon.location,
              phone: salon.phone,
              createdDate: salon.createdDate,
              imageUrl: salon.imageUrl,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSalonPage()),
          ).then((result) {
            if (result == true) {
              _fetchSalons(); // Refresh salons after creating
            }
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}


class SalonCard extends StatelessWidget {
  final String salonid;

  final String name;
  final String location;
  final String phone;
  final String createdDate;
  final String imageUrl;

  const SalonCard({
    Key? key,
    required this.salonid,

    required this.name,
    required this.location,
    required this.phone,
    required this.createdDate,
    required this.imageUrl,
  }) : super(key: key);

  factory SalonCard.fromJson(Map<String, dynamic> json) {
    return SalonCard(
      salonid: json['salonid']?.toString() ?? '',
      name: json['sname'] ?? '',
      location: json['slocation'] ?? '',
      phone: json['sphone'] ?? '',
      createdDate: json['screateddate'] ?? '',
      imageUrl: json['simage'] ?? 'https://via.placeholder.com/300x200.png?text=Salon+Image',
    );
  }

  Future<void> _deleteSalon(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'salonid': salonid, 'action': 'delete_salon'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salon deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete salon')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(location),
                const SizedBox(height: 8),
                Text('Phone: $phone'),
                const SizedBox(height: 8),
                Text('Created: $createdDate'),
              ],
            ),
          ),
          // Edit button
          IconButton(
            icon: Icon(Icons.edit, color: Colors.pink),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSalonPage(
                    salonid: salonid,
                    currentName: name,
                    currentLocation: location,
                    currentPhone: phone,
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  // Refresh the salon list after editing
                  // Trigger a refresh of the salon list here if needed
                }
              });
            },
          ),

          IconButton(
            icon: Icon(Icons.delete, color: Colors.pink),
            onPressed: () {
              _deleteSalon(context); // Call the delete function
            },
          ),
        ],
      ),
    );
  }
}

