import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kWhiteColor,
        title: const Text('Dashboard'),
        backgroundColor: kPrimaryColor,
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "New York, USA",
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
            const DrawerHeader(
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
              title: const Text('Profile'),
              leading: const Icon(Iconsax.user),
              onTap: () {
                context.push("/profile");
              },
            ),
            ListTile(
              title: const Text('Prescriptions'),
              leading: const Icon(Iconsax.document),
              onTap: () {
                context.push("/prescription");
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Iconsax.logout),
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search for doctors...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: Icon(Icons.search,
                        color:
                            Colors.grey), // Search icon inside the input field
                  ),
                  onTap: () {
                    context.go("/search");
                  },
                ),
              ),
              const SizedBox(height: 16), // Space between search bar and cards

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
                  const SizedBox(width: 16), // Space between the two cards
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
                    const Text(
                      "Nearby Doctors",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildDoctorList(),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.go("/search");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('View More Doctors'),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
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
              style: const TextStyle(
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
              child: const Text('Learn More'),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        leading: const CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/doctor_placeholder.jpg'), // Replace with actual doctor image
        ),
        title: Text(doctor['name']!),
        subtitle: Text(doctor['specialty']!),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to doctor details or booking
        },
      );
    }).toList(),
  );
}
