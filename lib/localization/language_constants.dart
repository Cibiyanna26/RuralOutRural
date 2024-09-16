// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:reach_out_rural/localization/demo_localization.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';

//languages code
const String ENGLISH = 'en';
const String SPANISH = 'es';
const String HINDI = 'hi';
const String BENGALI = 'bn';
const String TELUGU = 'te';
const String TAMIL = 'ta';
const String URDU = 'ur';
const String GUJARATI = 'gu';
const String KANNADA = 'kn';
const String ORIYA = 'or';
const String MALAYALAM = 'ml';
const String PUNJABI = 'pa';
const String ASSAMESE = 'as';
const String MARATHI = 'mr';
const String NEPALI = 'ne';
const String SINHALA = 'si';

Future<Locale> setLocale(String languageCode) async {
  final SharedPreferencesHelper prefs = SharedPreferencesHelper();
  await prefs.setString("language", languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final SharedPreferencesHelper prefs = SharedPreferencesHelper();
  String languageCode = await prefs.getString("language") ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case SPANISH:
      return const Locale(SPANISH, 'ES');
    case HINDI:
      return const Locale(HINDI, 'IN');
    case BENGALI:
      return const Locale(BENGALI, 'IN');
    case TELUGU:
      return const Locale(TELUGU, 'IN');
    case TAMIL:
      return const Locale(TAMIL, 'IN');
    case URDU:
      return const Locale(URDU, 'IN');
    case GUJARATI:
      return const Locale(GUJARATI, 'IN');
    case KANNADA:
      return const Locale(KANNADA, 'IN');
    case ORIYA:
      return const Locale(ORIYA, 'IN');
    case MALAYALAM:
      return const Locale(MALAYALAM, 'IN');
    case PUNJABI:
      return const Locale(PUNJABI, 'IN');
    case ASSAMESE:
      return const Locale(ASSAMESE, 'IN');
    case MARATHI:
      return const Locale(MARATHI, 'IN');
    case NEPALI:
      return const Locale(NEPALI, 'IN');
    case SINHALA:
      return const Locale(SINHALA, 'IN');
    default:
      return const Locale(ENGLISH, 'US');
  }
}

String getLanguageCode(String language) {
  switch (language) {
    case 'English':
      return ENGLISH;
    case 'Spanish':
      return SPANISH;
    case 'Hindi':
      return HINDI;
    case 'Bengali':
      return BENGALI;
    case 'Telugu':
      return TELUGU;
    case 'Tamil':
      return TAMIL;
    case 'Urdu':
      return URDU;
    case 'Gujarati':
      return GUJARATI;
    case 'Kannada':
      return KANNADA;
    case 'Oriya':
      return ORIYA;
    case 'Malayalam':
      return MALAYALAM;
    case 'Punjabi':
      return PUNJABI;
    case 'Assamese':
      return ASSAMESE;
    case 'Marathi':
      return MARATHI;
    case 'Nepali':
      return NEPALI;
    case 'Sinhala':
      return SINHALA;
    default:
      return ENGLISH;
  }
}

String getTranslated(BuildContext context, String key) {
  return DemoLocalizations.of(context).translate(key);
}
