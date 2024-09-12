import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _doctors = [
    "Dr. Smith",
    "Dr. Johnson",
    "Dr. Lee",
    "Dr. Davis",
    "Dr. Miller",
    // Add more doctor names or data here
  ];
  List<String> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = _doctors;
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = _doctors
          .where((doctor) => doctor.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Doctors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for doctors',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterDoctors,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredDoctors.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredDoctors[index]),
                    onTap: () {
                      // Handle doctor selection
                      // For example, navigate to a doctor detail page
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
