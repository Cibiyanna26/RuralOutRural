import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PrescriptionPage extends StatefulWidget {
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  List<File> _prescriptions = []; // List to hold the uploaded prescriptions
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadPrescription() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource
            .gallery); // Pick from gallery, you can also add camera option

    if (pickedFile != null) {
      setState(() {
        _prescriptions.add(File(pickedFile.path)); // Add the file to the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Prescriptions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload button
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text('Upload New Prescription'),
              onPressed: _uploadPrescription,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),

            SizedBox(height: 20),

            // Old Prescriptions List
            Text(
              'Previous Prescriptions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Scrollable list of uploaded prescriptions
            Expanded(
              child: _prescriptions.isEmpty
                  ? Center(child: Text('No prescriptions uploaded yet.'))
                  : ListView.builder(
                      itemCount: _prescriptions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.file(
                              _prescriptions[index],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text('Prescription ${index + 1}'),
                            subtitle: Text('Tap to view full details'),
                            onTap: () {
                              _viewPrescription(_prescriptions[index]);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to view prescription in full screen
  void _viewPrescription(File prescription) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPrescriptionView(prescription: prescription),
      ),
    );
  }
}

// Full screen view for a prescription
class FullPrescriptionView extends StatelessWidget {
  final File prescription;

  const FullPrescriptionView({Key? key, required this.prescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details'),
      ),
      body: Center(
        child: Image.file(prescription),
      ),
    );
  }
}
