import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SharedPreferencesHelper prefs = SharedPreferencesHelper();
  final api = ApiRepository();
  String? _name;
  String? _gender;
  String? _location;
  late Future<List<Doctor>> futureDoctors;

  @override
  void initState() {
    _getDoctors();
    _initProfile();
    super.initState();
  }

  void _search() async {
    final extra = await futureDoctors;
    // log("Extra: $extra");
    if (!mounted) return;
    context.push("/search", extra: extra);
  }

  void _initProfile() async {
    final SharedPreferencesHelper storage = SharedPreferencesHelper();
    final name = await storage.getString('name');
    final gender = await storage.getString("gender");
    final location = await storage.getString('location');

    final List<Location> locations =
        // ignore: body_might_complete_normally_catch_error
        await locationFromAddress(location!).catchError((e) {
      log(e);
    });
    final position = locations[0];
    final placeList =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placeList[0];
    final address =
        "${place.locality}, ${place.administrativeArea}, ${place.country}";

    setState(() {
      _name = name;
      _gender = gender;
      _location = address;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _initProfile();
  // }

  void _getDoctors() async {
    // Fetch nearby doctors
    setState(() {
      futureDoctors = api.getDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final asset = _gender == "Male"
        ? "assets/images/male.png"
        : "assets/images/female.png";
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kWhiteColor,
        title: const Text('Dashboard'),
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _location ?? "New Delhi",
                style: const TextStyle(fontSize: 16),
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
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: kWhiteColor,
                    backgroundImage:
                        AssetImage(asset), // Replace with actual image path
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String?>(
                      future: prefs.getString('name'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _name = snapshot.data;
                          return Text(
                            _name!,
                            style: const TextStyle(
                                color: kWhiteColor, fontSize: 20),
                          );
                        }

                        return const Text('User',
                            style: TextStyle(color: kWhiteColor, fontSize: 20));
                      })
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
                context.go("/login");
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
                    color: const Color(0xffEFEFEF),
                    borderRadius: BorderRadius.circular(14)),
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
                  onTap: _search,
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
                    FutureBuilder<List<Doctor>>(
                      future: futureDoctors,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final doctors = snapshot.data;
                          return Column(
                            children: doctors!.map((doctor) {
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hoverColor: kPrimaryColor.withOpacity(0.1),
                                splashColor: kPrimaryColor.withOpacity(0.1),
                                focusColor: kPrimaryColor.withOpacity(0.1),
                                leading: const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/default-doctor.png'),
                                  backgroundColor: Colors.white,
                                ),
                                title: Text(doctor.name!),
                                subtitle: Text(doctor.specialization!),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  // Navigate to doctor details or booking
                                  context.push("/doctor", extra: doctor);
                                },
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kWhiteColor,
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
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: ElevatedButton(
              onPressed: () {
                // Add navigation or action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Learn More',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
