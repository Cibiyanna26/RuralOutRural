import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reach_out_rural/localization/demo_localization.dart';
import 'package:reach_out_rural/localization/language_constants.dart';
import 'package:reach_out_rural/routes/routes.dart';
import 'package:reach_out_rural/themes/theme.dart';

class App extends StatefulWidget {
  const App({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  MaterialTheme theme = const MaterialTheme("OpenSans");
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    setUserLocale();
    super.didChangeDependencies();
  }

  void setUserLocale() async {
    final newLocale = await getLocale();
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Reach Out Rural',
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: router,
        localizationsDelegates: const [
          DemoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale ?? const Locale('en', 'US'),
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: const [
          Locale('en', "US"), // English
          Locale('es', "ES"), // Spanish
          // indian languages
          Locale('hi', "IN"), // Hindi
          Locale('bn', "IN"), // Bengali
          Locale('te', "IN"), // Telugu
          Locale('ta', "IN"), // Tamil
          Locale('ur', "IN"), // Urdu
          Locale('gu', "IN"), // Gujarati
          Locale('kn', "IN"), // Kannada
          Locale('or', "IN"), // Oriya
          Locale('ml', "IN"), // Malayalam
          Locale('pa', "IN"), // Punjabi
          Locale('as', "IN"), // Assamese
          Locale('mr', "IN"), // Marathi
          Locale('ne', "IN"), // Nepali
          Locale('si', "IN"), // Sinhala
        ]);
  }
}
