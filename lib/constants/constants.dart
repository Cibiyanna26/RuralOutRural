import 'package:flutter/material.dart';

const kprimaryColor = Color(0xFF027FFF);
const kgreyDotColor = Color(0xFFD8D8D8);
const kAnimationDuration = Duration(milliseconds: 300);

const IP = '192.168.0.126';
const BASE_URL = 'http://$IP:8000/api';
const TEXT_TO_TEXT = '/classify/v1/text-voice-generator/';

const List<String> onBoardingScreens = [
  'assets/animations/onboarding1.json',
  'assets/animations/onboarding2.json',
  'assets/animations/onboarding3.json',
];
