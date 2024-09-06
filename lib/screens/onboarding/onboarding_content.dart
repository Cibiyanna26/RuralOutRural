import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.currentPage,
  });
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          "Reach Out Rural",
          style: TextStyle(
            fontSize: SizeConfig.getProportionateTextSize(30),
            color: Theme.of(context).colorScheme.primary,
            fontVariations: const [
              FontVariation.weight(800),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Lottie.asset(
          onBoardingScreens[currentPage],
          height: SizeConfig.getProportionateScreenHeight(300),
          width: SizeConfig.getProportionateScreenWidth(300),
        ),
      ],
    );
  }
}
