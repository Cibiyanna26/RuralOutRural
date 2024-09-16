import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateTo() {
      Future.delayed(const Duration(seconds: 3), () {
        if (!context.mounted) return;
        context.go('/onboarding');
      });
    }

    navigateTo();
    SizeConfig.init(context);
    return Scaffold(
      body: Center(
        child: Text.rich(
          TextSpan(
            text: 'R',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: SizeConfig.getProportionateTextSize(85),
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'O',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: SizeConfig.getProportionateTextSize(55),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'R',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: SizeConfig.getProportionateTextSize(85),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
