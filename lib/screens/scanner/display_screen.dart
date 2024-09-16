import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final api = ApiRepository();
    final File image = File(imagePath);

    void navigateBackWithResult(String res) {
      context.pop([res]);
    }

    void sendAnalysis() async {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      final res = await api.predict(formData);
      if (res["error"] != null) {
        log('Error sending image: ${res["error"]}');
        return;
      }
      log('Analysis result: ${res["condition"]}');
      navigateBackWithResult(res["condition"]);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.file(image, fit: BoxFit.cover)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          heroTag: 'sendAnalysis',
          backgroundColor: kPrimaryColor,
          foregroundColor: kWhiteColor,
          onPressed: sendAnalysis,
          child: const Icon(
            Iconsax.tick_square,
            size: 35,
          ),
        ),
      ),
    );
  }
}
