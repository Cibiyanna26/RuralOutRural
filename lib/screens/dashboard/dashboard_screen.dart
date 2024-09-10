import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kWhiteColor,
        title: const Text('Dashboard'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Iconsax.location,
              size: 26,
            ),
            onPressed: () {
              // TODO: Implement location functionality
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search specialists or symptoms',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick action cards
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Book Appointments',
                      Iconsax.calendar_add,
                      () {
                        // TODO: Implement book appointments navigation
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      'Instant Video Consult',
                      Iconsax.video,
                      () {
                        // TODO: Implement video consult functionality
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nearby doctors section
              Text(
                'Nearby Doctors',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              // TODO: Implement a list or grid of nearby doctors

              const SizedBox(height: 20),

              // Nearby hospitals section
              Text(
                'Nearby Hospitals',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              // TODO: Implement a list of nearby hospitals
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 130,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48),
                  const SizedBox(height: 8),
                  Text(title, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
