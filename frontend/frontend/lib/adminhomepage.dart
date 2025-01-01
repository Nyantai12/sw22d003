import 'package:flutter/material.dart';
import 'package:frontend/ADprofile.dart';
import 'package:frontend/historyfetch.dart';
import 'package:frontend/login.dart';
import 'package:frontend/signup.dart';
import 'package:frontend/ADuilchilgee.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart'; // Make sure to import this for Lottie animations
// Import for the curved navigation bar
import 'sessioin_manager.dart';

class CustomHomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: FutureBuilder<String?>( // Asynchronous check for user ID
        future: SessionManager.getUid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            String uid = snapshot.data!;
            print(uid);
            return UschinApp();
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Login'),
              ),
            );
          }
        },
      ),
    );
  }
}

class UschinApp extends StatelessWidget {
  const UschinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: NewHomePage(),
    );
  }
}

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}
class _NewHomePageState extends State<NewHomePage> {
  int _selectedIndex = 0;

  final iconList = <IconData>[
    Icons.category,
    Icons.home,
    Icons.account_circle,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return NuurhuudasPage();
      case 1:
        return UilchilgeePage1();
      case 2:
        return HistoryPage();
      default:
        return UilchilgeePage1();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset(
          'assets/fer.json',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make scaffold background transparent
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GNav(
              rippleColor: Colors.pink[300]!,
              hoverColor: Colors.orange[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.pink[600]!,
              color: Colors.grey,
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              tabs: const [
                GButton(icon: Icons.home, text: 'AdНүүр'),
                GButton(icon: Icons.safety_divider, text: 'AdҮйлчилгээ'),
                GButton(icon: Icons.history, text: 'AdТүүх'),
                GButton(icon: Icons.school, text: 'AdСургалт'),
              ],
            ),
          ),
          body: _getPage(_selectedIndex),
        ),
      ],

    );
  }
}

class NuurhuudasPage extends StatefulWidget {
  @override
  _NuurhuudasPageState createState() => _NuurhuudasPageState();
}

class _NuurhuudasPageState extends State<NuurhuudasPage> {
  final PageController _pageController = PageController();
  final List<String> _images = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXdweLmXP6ILHUOxRDBr8ADPSaPBQ13QZNLg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLPf8lmBpvYCuSsuCjYTsNU9RpdWRSlpV0vQ&s',
    'https://images.squarespace-cdn.com/content/v1/5ee6452be52088397fce9ca0/5ed0faf5-37b4-4e38-b4bd-9219481c4dcb/MDG+SALON-+%2814+of+130%29.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'MBeauty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press (add your logic here)
              print('Notification button pressed!');
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.person_3),
            onPressed: () async {
              final userData = await SessionManager.getUserData();
              if (userData != null) {
                print("User Data: $userData");  // Debug print
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      fname: userData['fname']!,
                      lname: userData['lname']!,
                      uname: userData['uname']!,
                    ),
                  ),
                );
              } else {
                print("No user data found!");  // Debug print
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User details not available!")),
                );
              }
            },
          ),



          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(context, 'Бүгд', Icons.all_inclusive),
                    _buildFilterChip(context, 'Үсчин', Icons.cut),
                    _buildFilterChip(context, 'Маникюр', Icons.back_hand_rounded),
                    _buildFilterChip(context, 'Педикюр', Icons.airline_seat_legroom_extra_sharp),
                  ],
                ),
              ),
            ),
            const SectionTitle(title: 'Онцлох'),

            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns to the right
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20), // Adds 20 pixels of padding to the right
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UilchilgeePage1()),
                      );
                    },
                    child: Text(
                      'Бүгд',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16, color: Colors.pink),
                    ),
                  ),
                ),
              ],
            ),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  SizedBox(
                    width: 250,
                    height: 270,
                    child: SportsHallCard(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUJMMwfLHphu2QiNxL4m5G4E18xwcSuhO28Q&s',
                      name: 'Salon name 1',
                      location: 'Баянзүрх',
                      address: 'БЗД, Монел Аргал ойл колонкын хойно зам дагуу',
                      price: '30,000₮',
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 270,
                    child: SportsHallCard(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUJMMwfLHphu2QiNxL4m5G4E18xwcSuhO28Q&s',
                      name: 'Salon name 2',
                      location: 'Чингэлтэй',
                      address: 'ЧД, Зурагт Буурал эцэс',
                      price: '40,000₮',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 5,
                child: SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          _images[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        avatar: Icon(icon, color: Colors.pink),
        onSelected: (bool selected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NuurhuudasPage(),
            ),
          );
        },
      ),
    );
  }
}






class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SportsHallCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String address;
  final String price;

  const SportsHallCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.address,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 90, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.pink),
                    const SizedBox(width: 4),
                    Text(location),
                  ],
                ),
                const SizedBox(height: 4),
                Text(address),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
