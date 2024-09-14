import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Community {
  final String name;
  final int memberCount;
  final String description;
  final Icon icon;

  Community(
      {required this.name,
      required this.memberCount,
      required this.description,
      required this.icon});
}

List<Community> communities = [
  Community(
    name: 'Community 1',
    memberCount: 100,
    description:
        'This is a community for people who are interested in Flutter development.',
    icon: const Icon(Iconsax.activity),
  ),
  Community(
    name: 'Community 2',
    memberCount: 200,
    description:
        'This is a community for people who are interested in Android development.',
    icon: const Icon(Iconsax.alarm),
  ),
  Community(
    name: 'Community 3',
    memberCount: 300,
    description:
        'This is a community for people who are interested in iOS development.',
    icon: const Icon(Iconsax.clock),
  ),
  Community(
    name: 'Community 4',
    memberCount: 400,
    description:
        'This is a community for people who are interested in Web development.',
    icon: const Icon(Iconsax.cloud),
  ),
  Community(
    name: 'Community 5',
    memberCount: 500,
    description:
        'This is a community for people who are interested in UI/UX design.',
    icon: const Icon(Iconsax.bank),
  ),
];
