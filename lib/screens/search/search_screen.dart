import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/models/doctor.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.doctors});
  final List<Doctor> doctors;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  // final List<String> _doctors = [
  //   "Dr. Smith",
  //   "Dr. Johnson",
  //   "Dr. Lee",
  //   "Dr. Davis",
  //   "Dr. Miller",
  //   // Add more doctor names or data here
  // ];
  List<Doctor> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = widget.doctors;
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = widget.doctors
          .where((doctor) =>
              (doctor.name?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
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
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search for doctors',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: _filterDoctors,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = _filteredDoctors[index];
                  return ListTile(
                    title: Text(doctor.name ?? 'Unknown Doctor'),
                    onTap: () {
                      // Handle doctor selection
                      // For example, navigate to a doctor detail page
                      context.push("/doctor", extra: doctor);
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
