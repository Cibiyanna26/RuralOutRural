import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _controller;
  bool _isDetecting = false; // To simulate scanning process
  bool _isCameraInitialized = false; // Track if the camera is ready

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize camera when the page opens
  }

  // Initialize the camera when the user opens this page
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);

    try {
      await _controller?.initialize();
      setState(() {
        _isCameraInitialized = true; // Mark the camera as initialized
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Simulate a scan by capturing the image
  Future<void> _scanSkin() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final image = await _controller!.takePicture();

        setState(() {
          _isDetecting = true; // Start the scanning simulation
        });

        await Future.delayed(Duration(seconds: 2)); // Simulate scanning delay

        setState(() {
          _isDetecting = false; // Scanning complete
        });

        _showScanResultDialog("No disease detected. You are healthy!");
      } catch (e) {
        print(e);
      }
    }
  }

  // Show scan result in a dialog
  void _showScanResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Scan Result"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skin Disease Scanner"),
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_controller!), // Show the camera preview
                if (_isDetecting)
                  Center(
                    child: Container(
                      color: Colors.black54,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: _scanSkin,
                      child: Icon(Icons.camera),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading spinner while camera is initializing
    );
  }
}
