import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/localization/language_constants.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/hospital.dart';
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
  late Future<List<Hospital>> futureHospitals;
  late List<Doctor>? _localDoctors;
  late List<Hospital>? _localHospitals;

  @override
  void initState() {
    _getDoctors();
    _getHospitals();
    _initProfile();
    super.initState();
  }

  void _search() async {
    final extra = await futureDoctors;
    // log("Extra: $extra");
    if (!mounted) return;
    context.push("/search", extra: extra);
  }

  void _searchHospitals() async {
    final extra = await futureHospitals;
    // log("Extra: $extra");
    if (!mounted) return;
    context.push("/search-hospitals", extra: extra);
  }

  void _initProfile() async {
    final SharedPreferencesHelper storage = SharedPreferencesHelper();
    final name = await storage.getString('name');
    final gender = await storage.getString("gender");
    final doctors = await api.getDoctors();
    final hospitals = await api.getNearbyHospitals();
    final localDoctors = await storage.getString("doctors");
    final localHospitals = await storage.getString("hospitals");

    if (doctors.isNotEmpty) {
      log("Doctors: $doctors");
      final jsonDoctors = doctors.map((doctor) => doctor.toJson()).toList();
      await storage.setString("doctors", jsonEncode(jsonDoctors));
    }
    if (hospitals.isNotEmpty) {
      log("Hospitals: $hospitals");
      final jsonHospitals =
          hospitals.map((hospital) => hospital.toJson()).toList();
      await storage.setString("hospitals", jsonEncode(jsonHospitals));
    }
    if (!mounted) return;
    setState(() {
      _name = name;
      _gender = gender;
      _localDoctors = localDoctors != null
          ? (jsonDecode(localDoctors) as List)
              .map((doctor) => Doctor.fromJson(doctor))
              .toList()
          : null;
      _localHospitals = localHospitals != null
          ? (jsonDecode(localHospitals) as List)
              .map((hospital) => Hospital.fromJson(hospital))
              .toList()
          : null;
    });
    final location = await storage.getString('location');
    if (location != null) {
      final List<Location> locations =
          // ignore: body_might_complete_normally_catch_error
          await locationFromAddress(location).catchError((e) {
        log(e);
      });
      final position = locations[0];
      final placeList =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final place = placeList[0];
      final shortenedAddress = _shortenAddress(
        locality: place.locality,
        administrativeArea: place.administrativeArea,
        country: place.country,
      );
      // var address =
      //     "${place.locality}, ${place.administrativeArea}, ${place.country}";
      if (!mounted) return;
      setState(() {
        _location = shortenedAddress;
      });
    }
  }

  // @override
  // void didChangeDependencies() {
  //   _initProfile();
  //   super.didChangeDependencies();
  // }

  String _shortenAddress({
    String? locality,
    String? administrativeArea,
    String? country,
  }) {
    String shortenedAdministrativeArea = administrativeArea ?? '';
    String shortenedCountry = country ?? '';

    if (stateMap.containsKey(administrativeArea)) {
      shortenedAdministrativeArea = stateMap[administrativeArea]!;
    }

    if (countryMap.containsKey(country)) {
      shortenedCountry = countryMap[country]!;
    }

    return "${locality ?? ''}, $shortenedAdministrativeArea, $shortenedCountry";
  }

  void _getDoctors() async {
    // Fetch nearby doctors
    setState(() {
      futureDoctors = api.getDoctors();
    });
  }

  void _getHospitals() async {
    // Fetch nearby hospitals
    setState(() {
      futureHospitals = api.getNearbyHospitals();
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
        // title: const Text('Dashboard'),
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(
                    Iconsax.location,
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _location ?? "New Delhi",
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
                  Text(
                    _name ?? "User",
                    style: const TextStyle(color: kWhiteColor, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                getTranslated(context, "profile"),
              ),
              leading: const Icon(Iconsax.user),
              onTap: () {
                context.push("/profile");
              },
            ),
            ListTile(
              title: Text(
                getTranslated(context, "prescriptions"),
              ),
              leading: const Icon(Iconsax.document),
              onTap: () {
                context.push("/prescription");
              },
            ),
            ListTile(
              title: Text(
                getTranslated(context, "logout"),
              ),
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
                  style: const TextStyle(color: kBlackColor),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: kGreyColor),
                    hintText: getTranslated(context, "search_for_doctor"),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    prefixIcon: const Icon(Icons.search,
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
                      getTranslated(context, "book_appointment"),
                      'assets/images/appointment_image.jpg', // Replace with your image asset path
                      context,
                    ),
                  ),
                  const SizedBox(width: 16), // Space between the two cards
                  Expanded(
                    child: _buildCard(
                      getTranslated(context, "instant_vid_consultation"),
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
                    _localHospitals != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated(context, "local_hospitals"),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 213,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _localHospitals!.length,
                                  itemBuilder: (context, index) {
                                    return HospitalCard(
                                        hospital: _localHospitals![index]);
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _searchHospitals,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kWhiteColor,
                                ),
                                child: Text(getTranslated(
                                    context, "view_more_hospitals")),
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        : FutureBuilder<List<Hospital>>(
                            future: futureHospitals,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final hospitals = snapshot.data;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(
                                          context, "nearby_hospitals"),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 213,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: hospitals!.length,
                                        itemBuilder: (context, index) {
                                          return HospitalCard(
                                              hospital: hospitals[index]);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: _searchHospitals,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kWhiteColor,
                                      ),
                                      child: Text(getTranslated(
                                          context, "view_more_hospitals")),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                log('${snapshot.error}');
                                return const SizedBox.shrink();
                              }

                              return const SizedBox.shrink();
                              // return const Center(child: CircularProgressIndicator());
                            },
                          ),
                    Text(
                      getTranslated(context, "nearby_doctors"),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _localDoctors != null
                        ? Column(
                            children: _localDoctors!.map((doctor) {
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
                          )
                        : FutureBuilder<List<Doctor>>(
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
                                      hoverColor:
                                          kPrimaryColor.withOpacity(0.1),
                                      splashColor:
                                          kPrimaryColor.withOpacity(0.1),
                                      focusColor:
                                          kPrimaryColor.withOpacity(0.1),
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

                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kWhiteColor,
                      ),
                      child: Text(getTranslated(context, "view_more_doctors")),
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
              child: Text(getTranslated(context, "learn_more"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Navigate to hospital details or booking
          // context.push("/hospital", extra: hospital);
        },
        child: SizedBox(
          width: 185,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                    radius: 27,
                    child:
                        Icon(Iconsax.hospital, size: 27, color: Colors.blue)),
                const SizedBox(height: 8),
                Text(
                  hospital.name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hospital.speciality,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 3),
                Text(
                  '${hospital.distance.toStringAsFixed(1)} km away',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
