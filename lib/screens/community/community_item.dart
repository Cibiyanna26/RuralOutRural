import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/community.dart';

class CommunityItem extends StatelessWidget {
  final Community community;

  const CommunityItem({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24, // You can adjust the size
                  child: community.icon,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text('${community.memberCount} members'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              community.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement your "Join" action here
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor, // Change button color,
                  foregroundColor: kWhiteColor),
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
