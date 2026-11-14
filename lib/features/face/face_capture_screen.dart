/// Camera capture for face enroll/scan (v1.1.0). Returns the captured
/// photo's file path via Get.back(result: path), or null when cancelled.
/// Prefers the back camera (staff photographs the customer).
library;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen({super.key});

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  String? _error;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = 'এই device-এ ক্যামেরা পাওয়া যায়নি');
        return;
      }
      final camera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first);
      final controller = CameraController(camera, ResolutionPreset.medium,
          enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'ক্যামেরা চালু করা যায়নি — permission দিয়ে আবার চেষ্টা করুন');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _capturing) return;
    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      if (mounted) Get.back<String>(result: file.path);
    } catch (_) {
      if (mounted) {
        setState(() => _capturing = false);
        Get.snackbar('দুঃখিত', 'ছবি তোলা যায়নি — আবার চেষ্টা করুন',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('মুখের ছবি তুলুন')),
      body: _error != null
          ? Center(
              child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(_error!, textAlign: TextAlign.center),
            ))
          : controller == null
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  Expanded(child: CameraPreview(controller)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('মুখটা frame-এর মাঝখানে রাখুন, ভালো আলোতে তুলুন',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ]),
      floatingActionButton: controller == null || _error != null
          ? null
          : FloatingActionButton.large(
              onPressed: _capturing ? null : _capture,
              child: _capturing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.camera_alt)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
