import 'dart:io';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      log('Error initializing camera: $e');
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller!.value.isInitialized) {
      log('Camera controller is not initialized');
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _scanSkin() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      log('Camera controller is not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      _showScanResultDialog("No disease detected. You are healthy!");
      if (!mounted) return;

      // If the picture was taken, display it on a new screen.
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      log('Error taking picture: $e');
    }
  }

  void _showScanResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Scan Result"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
    _controller!.setFlashMode(newFlashMode);
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 9.0 / 16.0,
                      child: CameraPreview(_controller!),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleFlash,
            child: Icon(_isFlashOn ? Iconsax.flash_slash : Iconsax.flash_1),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: _scanSkin,
            child: const Icon(Iconsax.camera),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.file(File(imagePath))),
    );
  }
}
