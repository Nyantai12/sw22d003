import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  String errorMessage = '';
  String? uid;

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  // Fetch user ID from SharedPreferences
  Future<void> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid'); // Fetch user ID
    });

    if (uid != null) {
      _fetchHistory();
    } else {
      setState(() {
        errorMessage = 'User ID not found. Please log in again.';
        isLoading = false;
      });
    }
  }

  // Fetch history data from the API
  Future<void> _fetchHistory() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'historyfetch',
          'uid': uid,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['resultCode'] == 200) {
          // Extract the history from the 'action' field
          setState(() {
            history = List<Map<String, dynamic>>.from(data['action']['history'] ?? []);
          });
        } else {
          setState(() {
            errorMessage = data['resultMessage'] ?? 'Unknown error occurred.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch history. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching history: $e';
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
        title: const Text('Захиалга хийсэн түүхүүд'),
        backgroundColor: Colors.pink,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : history.isEmpty
          ? const Center(child: Text('Түүх олдсонгүй.'))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final historyItem = history[index];
          return Card(
            elevation: 3.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Салон: ${historyItem['sname'] ?? 'Тодорхойгүй'}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Үйлчилгээ: ${historyItem['servicename'] ?? 'Тодорхойгүй'}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Өдөр: ${historyItem['zahialgatsag'] ?? 'Тодорхойгүй'}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Төлөв: ${historyItem['zahialgatolow'] ?? 'Тодорхойгүй'}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Захиалга үүссэн огноо: ${historyItem['zcreateddate'] ?? 'Тодорхойгүй'}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),

    );
  }
}
