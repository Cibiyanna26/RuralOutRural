import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;
  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  late Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonStringValues =
        await rootBundle.loadString('lib/langs/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key]!;
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<DemoLocalizations> delegate =
      _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return languageList.contains(locale.languageCode);
  }

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    DemoLocalizations localization = DemoLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<DemoLocalizations> old) => false;
}
