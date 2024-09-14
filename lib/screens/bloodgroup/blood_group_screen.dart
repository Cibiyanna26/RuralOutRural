import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BloodGroupScreen extends StatefulWidget {
  const BloodGroupScreen({super.key});

  @override
  State<BloodGroupScreen> createState() => _BloodGroupScreenState();
}

class _BloodGroupScreenState extends State<BloodGroupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _continue() async {
    final SharedPreferencesHelper sharedPreferencesHelper =
        SharedPreferencesHelper();
    var bloodGroup =
        bloodGroupAssets[_currentPage].split("/").last.split(".").first;
    var bloodGroupType = bloodGroup.characters.last;
    bloodGroup = bloodGroup.substring(0, bloodGroup.length - 1);
    await sharedPreferencesHelper.setString("bloodGroup", bloodGroup);
    await sharedPreferencesHelper.setString("bloodGroupType", bloodGroupType);
    if (!mounted) return;
    context.go("/diagnosis");
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
              Text("What's your blood group?",
                  style: TextStyle(
                      fontSize: SizeConfig.getProportionateTextSize(25),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: bloodGroupAssets.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: index == _currentPage
                                ? kPrimaryColor.withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: index == _currentPage
                                    ? kPrimaryColor
                                    : Colors.transparent,
                                width: 5),
                          ),
                          child: SvgPicture.asset(
                            bloodGroupAssets[index],
                            height:
                                SizeConfig.getProportionateScreenHeight(100),
                            width: SizeConfig.getProportionateScreenWidth(100),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: bloodGroupAssets.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey[300]!,
                    activeDotColor: kPrimaryColor,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              DefaultButton(
                width: SizeConfig.getProportionateScreenWidth(320),
                height: SizeConfig.getProportionateScreenHeight(60),
                fontSize: SizeConfig.getProportionateTextSize(20),
                text: "Continue",
                press: _continue,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
