import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Community {
  final String name;
  final int memberCount;
  final String description;
  final Icon icon;
  final Color color;

  Community(
      {required this.name,
      required this.memberCount,
      required this.description,
      required this.icon,
      required this.color});
}

List<Community> communities = [
  Community(
    name: 'Cardiologist',
    memberCount: 100,
    description: 'This is a community for people who are need of Cardiologist.',
    icon: const Icon(Iconsax.heart, color: Colors.pinkAccent),
    color: Colors.pink,
  ),
  Community(
    name: 'Dentist',
    memberCount: 200,
    description: 'This is a community for people who are need of Dentist.',
    icon: const Icon(Iconsax.activity, color: Colors.blueAccent),
    color: Colors.blue,
  ),
  Community(
    name: 'Dermatologist',
    memberCount: 300,
    description:
        'This is a community for people who are need of Dermatologist.',
    icon: const Icon(Iconsax.personalcard, color: Colors.orangeAccent),
    color: Colors.orange,
  ),
  Community(
    name: 'Orthopedic',
    memberCount: 400,
    description: 'This is a community for people who are need of Orthopedic.',
    icon: const Icon(Iconsax.hospital, color: Colors.greenAccent),
    color: Colors.green,
  ),
  Community(
    name: 'Psychiatrist',
    memberCount: 500,
    description: 'This is a community for people who are need of Psychiatrist.',
    icon: const Icon(Iconsax.profile_2user, color: Colors.purpleAccent),
    color: Colors.purple,
  ),
];
