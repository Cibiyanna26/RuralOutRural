import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  late WeightSliderController _controller;
  double _weight = 30.0;

  void _continue() async {
    final SharedPreferencesHelper sharedPreferencesHelper =
        SharedPreferencesHelper();
    await sharedPreferencesHelper.setString("weight", _weight.toString());
    if (!mounted) return;

    context.go("/bloodgroup");
  }

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
        initialWeight: _weight, minWeight: 0, interval: 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text("What's your weight?",
                  style: TextStyle(
                      fontSize: SizeConfig.getProportionateTextSize(25),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Text(
                  "${_weight.toStringAsFixed(1)} kg",
                  style: TextStyle(
                      fontSize: SizeConfig.getProportionateTextSize(55),
                      fontWeight: FontWeight.w500),
                ),
              ),
              VerticalWeightSlider(
                unit: MeasurementUnit.kg,
                haptic: Haptic.lightImpact,
                controller: _controller,
                decoration: const PointerDecoration(
                  width: 130,
                  height: 3,
                  largeColor: Color(0xFF898989),
                  mediumColor: Color(0xFFC5C5C5),
                  smallColor: Color(0xFFF0F0F0),
                  gap: 30,
                ),
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
                indicator: Container(
                  height: 3,
                  width: 200,
                  alignment: Alignment.centerLeft,
                  color: Colors.red[300],
                ),
              ),
              const SizedBox(height: 20),
              DefaultIconButton(
                  width: SizeConfig.getProportionateScreenWidth(320),
                  height: SizeConfig.getProportionateScreenHeight(60),
                  fontSize: SizeConfig.getProportionateTextSize(20),
                  text: "Continue",
                  icon: Iconsax.arrow_right_35,
                  press: _continue),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
