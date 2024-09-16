import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/localization/language_constants.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:speech_to_text/speech_to_text.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  bool _isListening = false;
  late SpeechToText _speechToText;
  String _text = '';
  // double _confidence = 1.0;

  @override
  void initState() {
    _speechToText = SpeechToText();
    super.initState();
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => log('onStatus: $status'),
        onError: (errorNotification) => log('onError: $errorNotification'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
            // if (result.hasConfidenceRating && result.confidence > 0) {
            // _confidence = result.confidence;
            // }
          }),
          listenFor: const Duration(seconds: 10),
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
    }
  }

  void _navigate() {
    context.go("/");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  getTranslated(context, "bio"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _text.isNotEmpty
                      ? _text
                      : getTranslated(context, "diagnosis_desc"),
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(20),
                  ),
                ),
                // const SizedBox(height: 20),
                // Text(
                //   'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                //   style: const TextStyle(
                //     fontSize: 18,
                //     color: kPrimaryColor,
                //   ),
                // ),
                const SizedBox(height: 30),
                DefaultIconButton(
                    width: SizeConfig.getProportionateScreenWidth(320),
                    height: SizeConfig.getProportionateScreenHeight(60),
                    fontSize: SizeConfig.getProportionateTextSize(20),
                    text: getTranslated(context, "continue"),
                    icon: Iconsax.arrow_right_35,
                    press: _navigate),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: kPrimaryColor,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        child: SizedBox(
          width: SizeConfig.getProportionateScreenWidth(70),
          height: SizeConfig.getProportionateScreenHeight(75),
          child: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: _listen,
            child: Center(
              child: Icon(_isListening ? Iconsax.sound : Iconsax.microphone_2,
                  color: kWhiteColor, size: 45),
            ),
          ),
        ),
      ),
    );
  }
}
