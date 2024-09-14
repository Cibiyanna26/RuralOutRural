import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String _gender = "";

  void _navigate() async {
    final SharedPreferencesHelper prefs = SharedPreferencesHelper();
    await prefs.setString("gender", _gender);
    if (!mounted) return;

    context.go("/age");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text("What's your Age?",
                    style: TextStyle(
                        fontSize: SizeConfig.getProportionateTextSize(25),
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard(
                          "Male", "assets/animations/male.json", Iconsax.man,
                          () {
                        setState(() {
                          _gender = "Male";
                        });
                      }),
                      const SizedBox(width: 10),
                      _buildCard("Female", "assets/animations/female.json",
                          Iconsax.woman, () {
                        setState(() {
                          _gender = "Female";
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                DefaultIconButton(
                    width: SizeConfig.getProportionateScreenWidth(320),
                    height: SizeConfig.getProportionateScreenHeight(60),
                    fontSize: SizeConfig.getProportionateTextSize(20),
                    text: "Continue",
                    icon: Iconsax.arrow_right_35,
                    press: _navigate),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, String assetPath, IconData icon, Function() onTap) {
    return Card(
      shape: _gender == title
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: kPrimaryColor, width: 5),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: kPrimaryColor,
      elevation: 5,
      child: SizedBox(
        height: SizeConfig.getProportionateScreenHeight(220),
        width: SizeConfig.getProportionateScreenWidth(160),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: SizeConfig.getProportionateScreenHeight(150),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: kWhiteColor,
                ),
                child: Center(
                    child: Lottie.asset(assetPath,
                        height: SizeConfig.getProportionateScreenHeight(180),
                        width: SizeConfig.getProportionateScreenWidth(180))),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateTextSize(15),
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    icon,
                    size: 30,
                    color: kWhiteColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
