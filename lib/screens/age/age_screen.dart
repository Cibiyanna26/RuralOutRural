import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int _selectedAge = 18;

  void _navigate() async {
    final SharedPreferencesHelper prefs = SharedPreferencesHelper();
    await prefs.setString("age", _selectedAge.toString());
    if (!mounted) return;

    context.go("/height");
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
            Text("What's your age?",
                style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(25),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
                child: SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 50,
                looping: true,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedAge = index + 10;
                  });
                },
                children: _generateAge(),
              ),
            )),
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
      )),
    );
  }

  List<Widget> _generateAge() {
    final List<Widget> ageList = [];
    for (int i = 10; i <= 100; i++) {
      ageList.add(Center(
        child: Text(
          '$i',
          style: TextStyle(
            fontSize: 32,
            color: i == _selectedAge ? kPrimaryColor : kGreyColor,
          ),
        ),
      ));
    }
    return ageList;
  }
}
