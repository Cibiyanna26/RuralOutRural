import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_out_rural/models/edit_profile_objects.dart';
import 'dart:io';

import 'package:reach_out_rural/repository/storage/storage_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String _name = "";
  String _email = "";
  String _phone = "";
  String _age = "";
  String _location = "";

  final ImagePicker _picker = ImagePicker();

  void _initProfile() async {
    final SharedPreferencesHelper storage = SharedPreferencesHelper();
    final name = await storage.getString('name');
    final email = await storage.getString('email');
    final phone = await storage.getString('phoneNumber');
    final age = await storage.getString('age');
    // final latitude = await storage.getString('latitude');
    // final longitude = await storage.getString('longitude');
    final location = await storage.getString('location');

    setState(() {
      _name = name ?? "";
      _email = email ?? "";
      _phone = phone ?? "";
      _age = age?.toString() ?? "";
    });
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
      final address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      setState(() {
        _location = address;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _navigateToEditProfile() {
    EditProfileObjects params = EditProfileObjects(
      name: _name,
      email: _email,
      phone: _phone,
      age: _age,
      location: _location,
    );
    context.push("/edit-profile", extra: params);
  }

  @override
  void initState() {
    _initProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: _navigateToEditProfile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Iconsax.camera, size: 50, color: Colors.grey[700])
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _name.isNotEmpty ? _name : 'Name not set',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_email.isNotEmpty ? _email : 'Email not set'),
              const SizedBox(height: 10),
              Text(_phone.isNotEmpty ? _phone : 'Phone not set'),
              const SizedBox(height: 10),
              Text(_age.isNotEmpty ? 'Age: $_age' : 'Age not set'),
              const SizedBox(height: 10),
              Text(_location.isNotEmpty
                  ? 'Location: $_location'
                  : 'Location not set'),
            ],
          ),
        ),
      ),
    );
  }
}
