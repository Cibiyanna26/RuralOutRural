import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_out_rural/app/app.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/localization/language_constants.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/edit_profile_objects.dart';
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
import 'package:translator/translator.dart';

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
  final SharedPreferencesHelper prefs = SharedPreferencesHelper();
  int _currentIndex = 0;
  bool _isListening = false;
  late SpeechToText _speechToText;
  String _text = '';
  Locale _locale = const Locale('en');
  final translator = GoogleTranslator();

  final Map<String, String> languageMap = {
    'english': 'en',
    'ingles': 'en',
    'anglais': 'en',
    'eenglis': 'en',
    'spanish': 'es',
    'español': 'es',
    'espanol': 'es',
    'espanish': 'es',
    'hindi': 'hi',
    'hindee': 'hi',
    'telugu': 'te',
    'telugoo': 'te',
    'telgu': 'te',
    'tamil': 'ta',
    'thamil': 'ta',
    'tameel': 'ta',
    'kannada': 'kn',
    'kanada': 'kn',
    'kanadda': 'kn',
    'malayalam': 'ml',
    'malayalum': 'ml',
    'maliyalam': 'ml',
    'nepali': 'ne',
    'nepaalee': 'ne',
    'sinhala': 'si',
    'sinhalese': 'si',
    'bengali': 'bn',
    'bangla': 'bn',
    'bengalee': 'bn',
    'gujarati': 'gu',
    'gujrati': 'gu',
    'gujerati': 'gu',
    'marathi': 'mr',
    'marathee': 'mr',
    'oriya': 'or',
    'odia': 'or',
    'urdu': 'ur',
    'oordu': 'ur',
    'punjabi': 'pa',
    'panjabi': 'pa',
    'punjabee': 'pa',
    'assamese': 'as',
    'asamiya': 'as',
    'assamesse': 'as',
  };

  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.photos,
      // Permission.storage,
      // Permission.manageExternalStorage,
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

    // if (statuses[Permission.storage]!.isDenied) {
    //   final req = await Permission.storage.request();
    //   if (req.isPermanentlyDenied) {
    //     await openAppSettings();
    //   }
    // }

    // if (statuses[Permission.manageExternalStorage]!.isDenied) {
    //   final req = await Permission.manageExternalStorage.request();
    //   if (req.isPermanentlyDenied) {
    //     await openAppSettings();
    //   }
    // }

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

  void _changeLanguage(String languageCode) async {
    Locale locale = await setLocale(languageCode);
    setState(() {
      _locale = locale;
    });
    if (!mounted) return;
    App.setLocale(context, locale);
  }

  void _navigate(String command) async {
    if (command.isEmpty) {
      return;
    }
    final res = await api.checkNavigation({
      "query": command,
    });
    log(res.toString());
    if (res["error"] != null) {
      toaster.showErrorCustomToastWithIcon(res["data"]["error"]);
      return;
    }
    final category = res["category"];
    if (!mounted) return;
    if (category == "home") {
      setState(() {
        _currentIndex = 0; // Navigate to DashboardScreen
      });
    } else if (category == "medibot") {
      setState(() {
        _currentIndex = 1; // Navigate to ChatBotScreen
      });
    } else if (category == "mediscanner") {
      setState(() {
        _currentIndex = 2; // Navigate to ScannerPage
      });
    } else if (category == "community") {
      setState(() {
        _currentIndex = 3; // Navigate to PrescriptionPage
      });
    } else if (category == "edit_profile") {
      final name = await prefs.getString("name");
      final email = await prefs.getString("email");
      final phone = await prefs.getString("phoneNumber");
      final age = await prefs.getString("age");
      final location = await prefs.getString("location");
      var address = "";
      if (location != null) {
        final List<Location> locations =
            // ignore: body_might_complete_normally_catch_error
            await locationFromAddress(location).catchError((e) {
          log(e);
        });
        final position = locations[0];
        final placeList = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        final place = placeList[0];
        address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      EditProfileObjects params = EditProfileObjects(
        name: name ?? "",
        email: email ?? "",
        phone: phone ?? "",
        age: age ?? "",
        location: address,
      );
      if (!mounted) return;
      context.push("/edit-profile", extra: params);
    } else if (category == "search_doctor") {
      final doctors = await prefs.getString("doctors");
      if (doctors != null) {
        final List<dynamic> nearbyDoctors0 = jsonDecode(doctors);
        if (nearbyDoctors0.isNotEmpty) {
          final nearbyDoctors = nearbyDoctors0
              .map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
              .toList();
          if (!mounted) return;
          context.push("/search", extra: nearbyDoctors);
        }
      }
    } else if (category == "book_appointment") {
      context.push("/appointments");
    } else if (category == "user_profile") {
      context.push("/profile");
    } else if (category == "upload_prescription") {
      context.push("/prescription");
    } else if (category == "stop") {
      setState(() {
        _isListening = false;
        _text = '';
      });
      await _speechToText.stop();
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

  @override
  void didChangeDependencies() {
    logLocation();
    super.didChangeDependencies();
  }

  Future<void> _captureVoice() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        // final locales = await _speechToText.locales();
        // final localeNames = locales.map((locale) => locale.localeId).toList();
        setState(() {
          _isListening = true;
        });
        await _speechToText.listen(
          onResult: _onSpeechResult,
          pauseFor: const Duration(seconds: 5),
          listenFor: const Duration(seconds: 10),
          listenOptions: SpeechListenOptions(
            enableHapticFeedback: true,
          ),
          localeId: _locale.languageCode,
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _text = '';
      });
      await _speechToText.stop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    final command = result.recognizedWords.toLowerCase();
    setState(() {
      _text = command;
    });
    log(command);

    try {
      final translation = await translator.translate(command, to: 'en');
      final translatedCommand = translation.text.toLowerCase();
      log('Translated command: $translatedCommand');
      final detectedLanguage = _detectLanguage(translatedCommand);
      if (detectedLanguage != null) {
        _changeLanguage(detectedLanguage);
        return;
      }
    } catch (e) {
      log('Translation error: $e');
      // Proceed with original text if translation fails
    }
    if (command.contains('stop')) {
      setState(() {
        _isListening = false;
        _text = '';
      });
      _speechToText.stop();
    } else {
      _navigate(command);
    }
  }

  String? _detectLanguage(String command) {
    for (var entry in languageMap.entries) {
      // Check if the command contains the language name (case insensitive)
      if (_phoneticMatch(command, entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  bool _phoneticMatch(String text, String target) {
    // Simple phonetic matching algorithm
    String simplify(String s) {
      return s
          .toLowerCase()
          .replaceAll(RegExp(r'[aeiou]'), '') // Remove vowels
          .replaceAll(RegExp(r'(.)\1+'), r'$1'); // Remove repeated consonants
    }

    return simplify(text).contains(simplify(target));
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
