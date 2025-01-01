import 'package:flutter/material.dart';
import 'package:frontend/adminhomepage.dart';
import 'package:frontend/homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ADSalonDetPage extends StatefulWidget {
  final String salonid;

  const ADSalonDetPage({
    Key? key,
    required this.salonid,
  }) : super(key: key);

  @override
  State<ADSalonDetPage> createState() => _ADSalonDetPageState();
}

class _ADSalonDetPageState extends State<ADSalonDetPage> {
  Map<String, dynamic>? salonDetails;
  bool isLoading = true;
  String errorMessage = '';
  String? selectedDate;
  String? selectedSlot;
  String? selectedService;
  String? uid; // User ID will be fetched from SharedPreferences.
  String? selectedServiceId; // Store the selected service's ID
  List<String> dates = []; // List of available dates

  // Sample time slots (replace with API data if available)
  List<Map<String, dynamic>> timeSlots = [
    {'time': '10:00-11:00', 'price': '₮20,000', },
    {'time': '11:00-12:00', 'price': '₮20,000', },
    {'time': '12:00-13:00', 'price': '₮25,000', },
    {'time': '13:00-14:00', 'price': '₮25,000', },
    {'time': '14:00-15:00', 'price': '₮25,000', },
    {'time': '15:00-16:00', 'price': '₮25,000', },
    {'time': '16:00-17:00', 'price': '₮25,000', },
    {'time': '17:00-18:00', 'price': '₮25,000', },
  ];

  @override
  void initState() {
    super.initState();
    _fetchSalonDetails();
    _getUserID(); // Fetch user ID on initialization
    dates = _generateDates(); // Generate available dates
  }

  // Fetch user ID from SharedPreferences
  Future<void> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid'); // Change 'user_id' to 'uid'
    });
  }

  // Fetch salon details from the API
  Future<void> _fetchSalonDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'get_salondet',
          'salonid': widget.salonid,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['resultCode'] == 200) {
          setState(() {
            salonDetails = data['data']['salon'];
          });
        } else {
          setState(() {
            errorMessage = data['resultMessage'] ?? 'Unknown error occurred.';
          });
        }
      } else {
        setState(() {
          errorMessage =
          'Failed to fetch salon details. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching salon details: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Generate dates dynamically
  List<String> _generateDates() {
    DateTime now = DateTime.now();
    return List.generate(7, (index) {
      DateTime date = now.add(Duration(days: index));
      return date.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Салон дэлгэрэнгүй'),
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
          : salonDetails != null
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                salonDetails!['sname'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Байршил: ${salonDetails!['slocation'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Утас: ${salonDetails!['sphone'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Дэлгэрэнгүй: ${salonDetails!['sdescription'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ..._buildServiceList(
                  salonDetails!['services'] as List<dynamic>?),
              const SizedBox(height: 16),
              _buildDateSelector(),
              const SizedBox(height: 16),
              _buildSlotGrid(),
              const SizedBox(height: 16),
              _buildCreateOrderButton(),
            ],
          ),
        ),
      )
          : const Center(child: Text('Salon details not available.')),
    );
  }
  // Build service list
  List<Widget> _buildServiceList(List<dynamic>? services) {
    if (services == null || services.isEmpty) {
      return [
        const Text(
          'No services available.',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ];
    }

    return [
      const Text(
        'Үйлчилгээ сонгох:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: services.map<Widget>((service) {
            final serviceName = service['servicename'] ?? 'No name';
            final serviceId = service['serviceid'] != null
                ? service['serviceid'].toString()
                : ''; // Convert serviceid to String if it's not null

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedService == serviceName
                      ? Colors.white
                      : Colors.black,
                  backgroundColor: selectedService == serviceName
                      ? Colors.pink
                      : Colors.white,
                  side: BorderSide(color: Colors.pink, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedService = serviceName;
                    selectedServiceId = serviceId; // Update selectedServiceId
                  });
                },
                child: Text(serviceName),
              ),
            );
          }).toList(),
        ),
      ),
    ];
  }


  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Өдөр сонгох:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: dates.map<Widget>((date) {
              DateTime parsedDate = DateTime.parse(date);
              String formattedDay = "${parsedDate.day}";
              String formattedMonth = "${parsedDate.month}";
              String weekDayName = ['Дав', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня']
              [parsedDate.weekday - 1];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: selectedDate == date ? Colors.pink : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedDate == date ? Colors.pink : Colors.grey,
                      width: 2,
                    ),
                    boxShadow: selectedDate == date
                        ? [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekDayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: selectedDate == date ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDay,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedDate == date ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedMonth,
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedDate == date ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Slot grid widget
  Widget _buildSlotGrid() {
    List<Map<String, dynamic>> sortedTimeSlots = List.from(timeSlots);
    sortedTimeSlots.sort((a, b) {
      DateTime timeA = _parseTime(a['time']);
      DateTime timeB = _parseTime(b['time']);
      return timeA.compareTo(timeB);
    });


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Цаг сонгох:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
          ),
          itemCount: sortedTimeSlots.length,
          itemBuilder: (context, index) {
            final slot = sortedTimeSlots[index];
            final isBooked = slot['status'] == 'booked';

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: isBooked || selectedSlot == slot['time']
                    ? Colors.white
                    : Colors.black,
                backgroundColor: isBooked
                    ? Colors.grey
                    : (selectedSlot == slot['time'] ? Colors.pink : Colors
                    .white),
                side: BorderSide(
                    color: isBooked ? Colors.grey : Colors.pink, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isBooked
                  ? null
                  : () {
                setState(() {
                  selectedSlot = slot['time'];
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slot['time'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    slot['price'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  DateTime _parseTime(String time) {
    final startTime = time.split('-')[0]; // Extract the starting time (e.g., "10:00")
    final timeParts = startTime.split(':'); // Split hours and minutes
    final hour = int.parse(timeParts[0]); // Parse hour
    final minute = int.parse(timeParts[1]); // Parse minutes
    return DateTime(2024, 1, 1, hour, minute); // Create DateTime with default date
  }


  // Create Order Button
  Widget _buildCreateOrderButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _createOrder,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
        child: const Text('Захиалга үүсгэх', style: TextStyle(fontSize: 16,color: Colors.white)),
      ),
    );
  }

  Future<void> _createOrder() async {
    if (selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Үйлчилгээг сонгоно уу.')),
      );
      return;
    }

    if (selectedDate == null || selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Өдөр болон цагийг сонгоно уу.')),
      );
      return;
    }

    // Desired time slot
    String desiredTimeSlot = "$selectedDate, $selectedSlot";

    // Fetch existing orders to check for duplicates
    final checkExistingBody = {
      "action": "fetch_existing_orders",
      "salonid": widget.salonid,
      "serviceid": selectedServiceId,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(checkExistingBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if desiredTimeSlot exists in fetched data
        List existingSlots = data['existingSlots'] ?? [];
        bool isDuplicate = existingSlots.contains(desiredTimeSlot);

        if (isDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сонгосон цаг аль хэдийн захиалсан байна!')),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Алдаа гарлаа: ${response.statusCode}')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Алдаа гарлаа: $e')),
      );
      return;
    }

    // Proceed to create order if no duplicate exists
    final requestBody = {
      "action": "create_zahialga",
      "userid": uid,
      'salonid': widget.salonid,
      "serviceid": selectedServiceId,
      "zahialgatsag": desiredTimeSlot,
      "zahialgatolow": "Баталгаажсан",
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['resultCode'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Захиалга амжилттай үүсгэлээ!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomHomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['resultMessage'] ?? 'Төгссөнгүй!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Алдаа гарлаа: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Алдаа гарлаа: $e')),
      );
    }
  }



}
