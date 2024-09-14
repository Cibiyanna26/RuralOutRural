import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  RulerPickerController? _rulerPickerController;
  num currentValue = 40;

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 10, scale: 0.1),
    RulerRange(begin: 10, end: 100, scale: 0.5),
    RulerRange(begin: 100, end: 1000, scale: 0.10),
  ];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  void _continue() async {
    final SharedPreferencesHelper sharedPreferencesHelper =
        SharedPreferencesHelper();
    await sharedPreferencesHelper.setString("height", currentValue.toString());
    if (!mounted) return;

    context.go("/weight");
  }

  @override
  void dispose() {
    _rulerPickerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 10),
            Text("What's your height?",
                style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(25),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "${currentValue.toStringAsFixed(1)} cm",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.getProportionateTextSize(60)),
            ),
            const SizedBox(height: 30),
            RulerPicker(
              controller: _rulerPickerController!,
              onBuildRulerScaleText: (index, value) {
                return value.toInt().toString();
              },
              ranges: ranges,
              rulerScaleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: Colors.grey, width: 1.5, height: 30, scale: 0),
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 25, scale: 5),
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 15, scale: -1)
              ],
              onValueChanged: (value) {
                setState(() {
                  currentValue = value;
                });
              },
              width: SizeConfig.screenWidth,
              height: 100,
              rulerMarginTop: 35,
              marker: Container(
                  width: 8,
                  height: SizeConfig.getProportionateScreenHeight(110),
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(130),
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 30),
            DefaultIconButton(
                width: SizeConfig.getProportionateScreenWidth(320),
                height: SizeConfig.getProportionateScreenHeight(60),
                fontSize: SizeConfig.getProportionateTextSize(20),
                text: "Continue",
                icon: Iconsax.arrow_right_35,
                press: _continue),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
