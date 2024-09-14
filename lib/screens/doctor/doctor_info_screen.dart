import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class DoctorInfoScreen extends StatefulWidget {
  const DoctorInfoScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
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
          "Doctor Info",
          style: TextStyle(
              fontSize: SizeConfig.getProportionateTextSize(25),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset("assets/images/doctor-profile.jpg", height: 220),
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
                              fontSize: SizeConfig.getProportionateTextSize(30),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.doctor.specialization!,
                          style: TextStyle(
                              fontSize: SizeConfig.getProportionateTextSize(20),
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Row(
                          children: <Widget>[
                            IconTile(
                              backColor: Color(0xffFFECDD),
                              icon: Iconsax.directbox_send,
                              iconColor: Color(0xffFE7D6A),
                            ),
                            IconTile(
                              backColor: Color.fromARGB(255, 127, 100, 95),
                              icon: Iconsax.call_calling,
                              iconColor: Colors.white,
                            ),
                            IconTile(
                              backColor: Color(0xffEBECEF),
                              icon: Iconsax.video,
                              iconColor: kBlackColor,
                            ),
                          ],
                        )
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
                "Dr. Stefeni Albert is a cardiologist in Nashville & affiliated with multiple hospitals in the area.He received his medical degree from Duke University School of Medicine and has been in practice for more than 20 years.",
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
                          Icon(
                            Iconsax.location,
                            // color: Colors.black87.withOpacity(0.7),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Address",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 268,
                                  child: Text(
                                    widget.doctor.locationName!,
                                    style: const TextStyle(color: Colors.grey),
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
                          Icon(
                            Iconsax.clock,
                            // color: Colors.black87.withOpacity(0.7),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Daily Timings",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 268,
                                  child: const Text(
                                    '''Monday - Friday
Open till 7 Pm''',
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
                                  borderRadius: BorderRadius.circular(16)),
                              child: const Icon(Iconsax.document_text1,
                                  color: Colors.white)),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 130,
                            child: const Text(
                              "List Of Schedule",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
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
                                  borderRadius: BorderRadius.circular(16)),
                              child: const Icon(Iconsax.document_text1,
                                  color: Colors.white)),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 130,
                            child: const Text(
                              "Doctor's Daily Post",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
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
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
