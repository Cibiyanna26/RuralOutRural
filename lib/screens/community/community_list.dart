import 'package:flutter/material.dart';
import 'package:reach_out_rural/models/community.dart';
import 'package:reach_out_rural/screens/community/community_item.dart';

class CommunityList extends StatelessWidget {
  final List<Community> communities; // Data from your app

  const CommunityList({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community = communities[index];
          return CommunityItem(community: community);
        },
      ),
    );
  }
}