import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/screens/chatbot/chat_bot_screen.dart';
import 'package:reach_out_rural/screens/community/community_screen.dart';
import 'package:reach_out_rural/screens/dashboard/dashboard_screen.dart';
import 'package:reach_out_rural/screens/scanner/scanner_screen.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:reach_out_rural/widgets/custom_bottom_navbar.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

const List<Widget> _screens = <Widget>[
  DashboardScreen(),
  ChatBotScreen(),
  ScannerScreen(),
  CommunityScreen()
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final toaster = ToastHelper();
  final api = ApiRepository();
  int _currentIndex = 0;
  bool _isListening = false;
  late SpeechToText _speechToText;
  String _text = '';

  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.photos,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
    LocationPermission permission = await Geolocator.checkPermission();

    if (statuses[Permission.microphone]!.isDenied) {
      final req = await Permission.microphone.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (statuses[Permission.camera]!.isDenied) {
      final req = await Permission.camera.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (statuses[Permission.location]!.isDenied) {
      final req = await Permission.location.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (permission == LocationPermission.denied) {
      final req = await Geolocator.requestPermission();
      if (req == LocationPermission.deniedForever) {
        await openAppSettings();
      }
    }
    if (statuses[Permission.locationWhenInUse]!.isDenied) {
      final req = await Permission.locationWhenInUse.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (statuses[Permission.photos]!.isDenied) {
      final req = await Permission.photos.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (statuses[Permission.storage]!.isDenied) {
      final req = await Permission.storage.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (statuses[Permission.manageExternalStorage]!.isDenied) {
      final req = await Permission.manageExternalStorage.request();
      if (req.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    log(statuses.toString());
  }

  // void logUserDetails() async {
  //   final SharedPreferencesHelper prefs = SharedPreferencesHelper();
  //   final int? age = await prefs.getString("age");
  //   final String? gender = await prefs.getString("gender");
  //   final String? height = await prefs.getString("height");
  //   final String? weight = await prefs.getString("weight");
  //   final String? phoneNumber = await prefs.getString("phoneNumber");
  //   final String? bloodGroup = await prefs.getString("bloodGroup");
  //   final String? bloodGroupType = await prefs.getString("bloodGroupType");
  //   final String? token = await prefs.getString("token");
  //   log("User Details: $age");
  //   log("User Details: $gender");
  //   log("User Details: $height");
  //   log("User Details: $weight");
  //   log("User Details: $phoneNumber");
  //   log("User Details: $bloodGroup");
  //   log("User Details: $bloodGroupType");
  //   log("User Details: $token");
  // }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled. Please enable it.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied. Please enable it.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions. Please enable it.');
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }

  void logLocation() async {
    try {
      final Position position = await _determinePosition();
      log("Location: ${position.latitude}, ${position.longitude}");
      final SharedPreferencesHelper prefs = SharedPreferencesHelper();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // log("Placemarks: $placemarks");
      Placemark place = placemarks[0];
      log("Place: ${place.name}");
      prefs.setString("latitude", position.latitude.toString());
      prefs.setString("longitude", position.longitude.toString());
      prefs.setString("location", jsonEncode(place.toJson()));
      final phoneNumber = await prefs.getString("phoneNumber");
      Map<String, dynamic> data = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'phonenumber': phoneNumber,
      };
      log("Data: $data");
      // final res = await api.checkNavigation(data);
      // log("Response: $res");
    } catch (e) {
      log("Error: $e");
      toaster.showToast("Error: $e");
    }
  }

  @override
  void initState() {
    // logUserDetails();
    _requestPermission();
    logLocation();
    super.initState();
    _speechToText = SpeechToText();
  }

  // @override
  // void didChangeDependencies() {
  //   logLocation();
  //   super.didChangeDependencies();
  // }

  Future<void> _captureVoice() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        await _speechToText.listen(
            onResult: _onSpeechResult,
            pauseFor: const Duration(seconds: 5),
            listenFor: const Duration(seconds: 10),
            listenOptions: SpeechListenOptions(
              enableHapticFeedback: true,
            ));
      }
    } else {
      setState(() {
        _isListening = false;
        _text = '';
      });
      await _speechToText.stop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final command = result.recognizedWords.toLowerCase();
    setState(() {
      _text = command;
    });
    log(command);
    if (command.contains('home')) {
      setState(() {
        _currentIndex = 0; // Navigate to DashboardScreen
      });
    } else if (command.contains('chat')) {
      setState(() {
        _currentIndex = 1; // Navigate to ChatBotScreen
      });
    } else if (command.contains('scan') || command.contains('wound')) {
      setState(() {
        _currentIndex = 2; // Navigate to ScannerPage
      });
    } else if (command.contains('community')) {
      setState(() {
        _currentIndex = 3; // Navigate to PrescriptionPage
      });
    } else if (command.contains('profile')) {
      context.push("/profile");
    } else if (command.contains('prescription')) {
      context.push("/prescription");
    } else if (command.contains('stop')) {
      setState(() {
        _isListening = false;
        _text = '';
      });
      _speechToText.stop();
    }
  }

  void _onPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    toaster.init(context);
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          if (_text.isNotEmpty)
            Positioned(
              bottom: 45,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // This makes sure it stays compact
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_text,
                          style: TextStyle(
                              color: kBlackColor,
                              fontSize:
                                  SizeConfig.getProportionateTextSize(20))),
                    ),
                  ],
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavbar(
        isListening: _isListening,
        currentIndex: _currentIndex,
        onPressed: _onPressed,
        onCaptureVoice: _captureVoice,
      ),
    );
  }
}
