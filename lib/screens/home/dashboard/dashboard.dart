import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // TODO: Implement location functionality
            },
          ),
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
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Quick action cards
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Book Appointments',
                      Icons.calendar_today,
                      () {
                        // TODO: Implement book appointments navigation
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      'Instant Video Consult',
                      Icons.video_call,
                      () {
                        // TODO: Implement video consult functionality
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Nearby doctors section
              Text(
                'Nearby Doctors',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              // TODO: Implement a list or grid of nearby doctors

              SizedBox(height: 20),

              // Nearby hospitals section
              Text(
                'Nearby Hospitals',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              // TODO: Implement a list of nearby hospitals
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48),
              SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
