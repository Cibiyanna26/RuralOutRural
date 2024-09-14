import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.location,
  });
  final String name;
  final String email;
  final String phone;
  final String age;
  final String location;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final api = ApiRepository();
  final toaster = ToastHelper();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _ageController.text = widget.age;
    _locationController.text = widget.location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final age = _ageController.text;
    final location = _locationController.text;
    final SharedPreferencesHelper storage = SharedPreferencesHelper();
    storage.setString('name', name);
    storage.setString('email', email);
    storage.setString('phoneNumber', phone);
    storage.setString('age', age);
    storage.setString('location', location);
    final List<Location> locations =
        // ignore: body_might_complete_normally_catch_error
        await locationFromAddress(location).catchError((e) {
      log(e);
    });
    storage.setString('latitude', locations[0].latitude.toString());
    storage.setString('longitude', locations[0].longitude.toString());
    final gender = await storage.getString("gender");
    final height = await storage.getString('height');
    final weight = await storage.getString('weight');
    final bloodGroup = await storage.getString('bloodGroup');
    final bloodGroupType = await storage.getString('bloodGroupType');
    final res = await api.updateProfile({
      "name": name,
      "email": email,
      "phonenumber": phone,
      "age": age,
      "gender": gender,
      "latitude": locations[0].latitude.toString(),
      "longitude": locations[0].longitude.toString(),
      "height": double.parse(height!),
      "weight": double.parse(weight!),
      "bloodgroup": bloodGroup,
      "bloodgrouptype": bloodGroupType,
    });
    log(res.toString());
    if (res["error"] != null) {
      toaster.showErrorCustomToastWithIcon(res["data"]["error"]);
      return;
    }
    log(res.toString());
    toaster.showSuccessCustomToastWithIcon("Profile updated successfully");
    // if (!mounted) return;
    // context.pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.save),
        //       onPressed: _saveProfile,
        //     ),
        //     const SizedBox(width: 8),
        //   ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DefaultIconButton(
                width: SizeConfig.getProportionateScreenWidth(320),
                height: SizeConfig.getProportionateScreenHeight(60),
                fontSize: SizeConfig.getProportionateTextSize(20),
                text: "Save",
                icon: Iconsax.tick_square,
                press: _saveProfile),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
