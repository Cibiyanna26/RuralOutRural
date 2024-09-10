import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_button.dart';

final defaultPinTheme = PinTheme(
  width: 90,
  height: 90,
  textStyle: TextStyle(
    fontSize: SizeConfig.getProportionateTextSize(24),
    color: Colors.black,
  ),
  decoration: BoxDecoration(
    color: const Color(0x91DEE7F0),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.transparent),
  ),
);

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.getProportionateScreenHeight(50)),
        Pinput(
          // controller: controller.otp,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: kPrimaryColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: (pin) => {},
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        SizedBox(height: SizeConfig.getProportionateScreenHeight(45)),
        DefaultButton(
            text: "Continue",
            width: SizeConfig.getProportionateScreenWidth(350),
            height: SizeConfig.getProportionateScreenHeight(60),
            fontSize: SizeConfig.getProportionateTextSize(18),
            press: () => context.go("/")),
      ],
    );
  }
}
