import 'package:flutter/material.dart';
import 'package:reach_out_rural/routes/routes.dart';
import 'package:reach_out_rural/themes/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    MaterialTheme theme = const MaterialTheme("OpenSans");

    return MaterialApp.router(
      title: 'Reach Out Rural',
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      routerConfig: router,
    );
  }
}
