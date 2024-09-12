import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final SharedPreferencesHelper prefs = SharedPreferencesHelper();
  final authRepository = ApiRepository();
  String _phoneNumber = "";

  void _login() async {
    final data =
        await authRepository.patientLogin({"phonenumber": _phoneNumber});
    await prefs.setString("phoneNumber", _phoneNumber);
    await prefs.setString("token", data["token"]);

    if (!mounted) return;

    context.go("/otp/$_phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  "assets/icons/logo.svg",
                  height: SizeConfig.getProportionateScreenHeight(125),
                  width: SizeConfig.getProportionateScreenWidth(125),
                ),
                const SizedBox(height: 15),
                Text(
                  'Login',
                  style: TextStyle(
                      fontSize: SizeConfig.getProportionateTextSize(32),
                      fontVariations: const [FontVariation.weight(800)]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Let's experience the joy of telecare AI.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: SizeConfig.getProportionateScreenHeight(35),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateTextSize(16),
                      fontVariations: const [FontVariation.weight(700)],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                IntlPhoneField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _phoneNumber = value.number;
                    })
                  },
                  onSubmitted: (phoneNumber) => {
                    setState(() {
                      _phoneNumber = phoneNumber;
                    })
                  },
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  dropdownTextStyle: const TextStyle(
                    fontVariations: [FontVariation.weight(700)],
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  initialCountryCode: 'IN',
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(20),
                  ),
                ),
                // const SizedBox(height: 15),
                // SizedBox(
                //   width: double.infinity,
                //   height: SizeConfig.getProportionateScreenHeight(35),
                //   child: Text(
                //     "Password",
                //     style: TextStyle(
                //       fontSize: SizeConfig.getProportionateTextSize(16),
                //       fontVariations: const [FontVariation.weight(700)],
                //     ),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                // TextField(
                //   obscureText: true,
                //   decoration: InputDecoration(
                //     labelText: 'Password',
                //     prefixIcon: Padding(
                //       padding: const EdgeInsets.only(left: 5),
                //       child: IconButton(
                //           icon: const Icon(Icons.lock_outline),
                //           onPressed: () {}),
                //     ),
                //     suffixIcon: Padding(
                //       padding: const EdgeInsets.only(right: 5),
                //       child: IconButton(
                //           icon: const Icon(Icons.visibility_off_outlined),
                //           onPressed: () {}),
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                //   style: TextStyle(
                //     fontSize: SizeConfig.getProportionateTextSize(20),
                //   ),
                // ),
                const SizedBox(height: 35),
                DefaultButton(
                  height: SizeConfig.getProportionateScreenHeight(56),
                  width: SizeConfig.getProportionateScreenWidth(400),
                  text: "Login",
                  press: _login,
                  fontSize: SizeConfig.getProportionateTextSize(20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      child: const Text('Register',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontVariations: [FontVariation.weight(700)])),
                      onPressed: () {
                        context.go('/register');
                      },
                    ),
                  ],
                ),
                TextButton(
                  child: const Text('Need Help?',
                      style: TextStyle(color: kPrimaryColor)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
