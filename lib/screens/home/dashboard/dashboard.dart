import 'package:flutter/material.dart';
import 'package:reach_out_rural/screens/profile/profile.dart';
import 'package:reach_out_rural/screens/home/prescription_page/prescription_page.dart';
import 'package:reach_out_rural/screens/home/search_screen.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Simulate fetching the user location
  Future<void> _getUserLocation() async {
    // Replace this with actual location fetching logic
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _userLocation = "New York, USA"; // Example location
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _userLocation,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/profile.jpg'), // Replace with actual image path
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Prescriptions'),
              leading: Icon(Icons.file_copy),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrescriptionPage()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search input below the top app bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for doctors...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: Icon(Icons.search,
                        color:
                            Colors.grey), // Search icon inside the input field
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
              ),
              SizedBox(height: 16), // Space between search bar and cards

              // Row with two cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildCard(
                      'Book Appointments',
                      'assets/images/appointment_image.jpg', // Replace with your image asset path
                      context,
                    ),
                  ),
                  SizedBox(width: 16), // Space between the two cards
                  Expanded(
                    child: _buildCard(
                      'Instant Video Consultation',
                      'assets/images/video_consultation_image.jpg', // Replace with your image asset path
                      context,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nearby Doctors",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildDoctorList(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      child: Text('View More Doctors'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String imagePath, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                // Add navigation or action here
              },
              child: Text('Learn More'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCard(
    {required String title, required String image, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 150,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDoctorList() {
  // Sample list of nearby doctors
  final List<Map<String, String>> doctors = [
    {'name': 'Dr. John Doe', 'specialty': 'Cardiologist'},
    {'name': 'Dr. Jane Smith', 'specialty': 'Dermatologist'},
    {'name': 'Dr. Michael Brown', 'specialty': 'General Physician'},
  ];

  return Column(
    children: doctors.map((doctor) {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/doctor_placeholder.jpg'), // Replace with actual doctor image
        ),
        title: Text(doctor['name']!),
        subtitle: Text(doctor['specialty']!),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to doctor details or booking
        },
      );
    }).toList(),
  );
}
