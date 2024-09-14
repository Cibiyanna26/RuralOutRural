import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/community.dart';
import 'package:reach_out_rural/screens/community/community_list.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Community'),
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          CommunityList(
            communities: communities,
          ),
        ],
      ),
    );
  }
}
