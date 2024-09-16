import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/localization/language_constants.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class DoctorInfoScreen extends StatefulWidget {
  const DoctorInfoScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  final toaster = ToastHelper();
  final api = ApiRepository();
  final prefs = SharedPreferencesHelper();
  final _speechToText = SpeechToText();
  final _tts = FlutterTts();
  final translator = GoogleTranslator();
  bool _isListening = false;
  String _text = '';
  Locale? _locale;

  @override
  void initState() {
    _initLanguage();
    super.initState();
    _initSpeech();
  }

  Future<void> _initLanguage() async {
    final locale = await getLocale();
    log(locale.languageCode);
    setState(() {
      _locale = locale;
    });
    await _tts.setLanguage(locale
        .languageCode); // Set initial language to English (adjust as needed)
    await _tts.setSpeechRate(0.5); // Adjust speech rate
  }

  Future<void> _initSpeech() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = false;
        _text = '';
      });
    }
  }

  Future<void> _captureVoice() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        await _speechToText.listen(
          onResult: _onSpeechResult,
          pauseFor: const Duration(seconds: 5),
          listenFor: const Duration(seconds: 10),
          listenOptions: SpeechListenOptions(
            enableHapticFeedback: true,
          ),
          localeId: _locale!
              .languageCode, // Set your locale based on the user's preferred language
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _text = '';
      });
      await _speechToText.stop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    final command = result.recognizedWords.toLowerCase();
    setState(() {
      _text = command;
    });
    log(command);
    var translatedCommand = command;
    try {
      final translation = await translator.translate(command, to: 'en');
      translatedCommand = translation.text.toLowerCase();
      log('Translated command: $translatedCommand');
    } catch (e) {
      log('Translation error: $e');
      // Proceed with original text if translation fails
    }
    if (translatedCommand.contains('name')) {
      _speak(widget.doctor.name!);
    } else if (translatedCommand.contains('bio')) {
      _speak(widget.doctor.bio ?? "Doctor's Bio");
    } else if (translatedCommand.contains('specialization') ||
        translatedCommand.contains('specialisation') ||
        translatedCommand.contains('specialty')) {
      _speak(widget.doctor.specialization!);
    } else if (translatedCommand.contains('location')) {
      _speak(widget.doctor.locationName!);
    } else if (translatedCommand.contains('address')) {
      _speak(widget.doctor.locationName!);
    } else if (translatedCommand.contains('daily timings')) {
      _speak("Monday - Friday\nOpen till 7 Pm");
    } else if (translatedCommand.contains('appointment') ||
        translatedCommand.contains('book appointment')) {
      await _stopSpeech();
      if (!mounted) return;
      context.push('/appointments');
    } else if (translatedCommand.contains('stop')) {
      await _stopSpeech();
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
    await _stopSpeech();
  }

  Future<void> _stopSpeech() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
      _text = '';
    });
  }

  @override
  void dispose() {
    _speechToText.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: SizedBox(
          width: 50,
          height: 50,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: 32,
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        title: Text(
          getTranslated(context, "doctor_info"),
          style: TextStyle(
              fontSize: SizeConfig.getProportionateTextSize(25),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset("assets/images/doctor-profile.jpg",
                            height: 220),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 222,
                          height: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.doctor.name!,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.getProportionateTextSize(30),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.doctor.specialization!,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.getProportionateTextSize(20),
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconTile(
                                    backColor: Color(0xffFFECDD),
                                    icon: Iconsax.directbox_send,
                                    iconColor: Color(0xffFE7D6A),
                                  ),
                                  IconTile(
                                    backColor:
                                        Color.fromARGB(255, 127, 100, 95),
                                    icon: Iconsax.call_calling,
                                    iconColor: Colors.white,
                                  ),
                                  IconTile(
                                    backColor: Color(0xffEBECEF),
                                    icon: Iconsax.video,
                                    iconColor: kBlackColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Text(
                      "About",
                      style: TextStyle(
                          fontSize: SizeConfig.getProportionateTextSize(30),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.doctor.bio ?? "Doctor's Bio",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.getProportionateTextSize(16)),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Iconsax.location,
                                  // color: Colors.black87.withOpacity(0.7),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "Address",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                268,
                                        child: Text(
                                          widget.doctor.locationName!,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ))
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Iconsax.clock,
                                  // color: Colors.black87.withOpacity(0.7),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "Daily Timings",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                268,
                                        child: const Text(
                                          '''Monday - Friday\nOpen till 7 Pm''',
                                          style: TextStyle(color: Colors.grey),
                                        ))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/images/map.png",
                          width: SizeConfig.getProportionateScreenWidth(160),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Activity",
                      style: TextStyle(
                          // color: Color(0xff242424),
                          fontSize: SizeConfig.getProportionateTextSize(30),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                                color: const Color(0xffFBB97C),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffFCCA9B),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: const Icon(Iconsax.document_text1,
                                        color: Colors.white)),
                                const SizedBox(
                                  width: 16,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      130,
                                  child: Text(
                                    "List Of Schedule",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.getProportionateTextSize(
                                                14)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                                color: const Color(0xffA5A5A5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffBBBBBB),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: const Icon(Iconsax.document_text1,
                                        color: Colors.white)),
                                const SizedBox(
                                  width: 16,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      120,
                                  child: Text(
                                    "Doctor's Daily Post",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.getProportionateTextSize(
                                                14)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultIconButton(
                        width: SizeConfig.getProportionateScreenWidth(320),
                        height: SizeConfig.getProportionateScreenHeight(60),
                        fontSize: SizeConfig.getProportionateTextSize(20),
                        text: getTranslated(context, "book_appointment"),
                        icon: Iconsax.calendar_add,
                        press: () {
                          context.push('/appointments');
                        }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (_text.isNotEmpty)
                Positioned(
                  bottom: SizeConfig.getProportionateScreenHeight(190),
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // This makes sure it stays compact
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_text,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontSize:
                                      SizeConfig.getProportionateTextSize(20))),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: kErrorColor,
        duration: const Duration(milliseconds: 1000),
        child: SizedBox(
          width: 75,
          height: 75,
          child: FloatingActionButton(
            backgroundColor: kErrorColor,
            foregroundColor: kWhiteColor,
            onPressed: _captureVoice,
            child: Icon(_isListening ? Iconsax.sound : Iconsax.microphone_2,
                size: 40),
          ),
        ),
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  final IconData? icon;
  final Color? backColor;
  final Color? iconColor;

  const IconTile({super.key, this.icon, this.backColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          color: backColor, borderRadius: BorderRadius.circular(15)),
      child: Icon(icon, color: iconColor),
    );
  }
}
