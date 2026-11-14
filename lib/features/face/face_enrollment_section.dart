/// Face enrollment card for the person profile (v1.1.0): enroll up to 3
/// samples, see status, or remove the enrollment. Embeddings stay on
/// this device only (see docs/FACE_RECOGNITION.md).
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/face_recognition.dart';
import 'face_capture_screen.dart';
import 'face_controller.dart';

class FaceEnrollmentSection extends StatefulWidget {
  const FaceEnrollmentSection({super.key, required this.personId});
  final String personId;

  @override
  State<FaceEnrollmentSection> createState() => _FaceEnrollmentSectionState();
}

class _FaceEnrollmentSectionState extends State<FaceEnrollmentSection> {
  FaceEnrollment? _enrollment;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final e = await Get.find<FaceController>().enrollmentOf(widget.personId);
    if (mounted) setState(() => _enrollment = e);
  }

  Future<void> _enroll() async {
    final path = await Get.to<String>(() => const FaceCaptureScreen());
    if (path == null || !mounted) return;
    setState(() => _busy = true);
    final error =
        await Get.find<FaceController>().enrollFromPhoto(widget.personId, path);
    if (!mounted) return;
    setState(() => _busy = false);
    Get.snackbar(
      error == null ? 'সফল' : 'হয়নি',
      error ?? 'Face enroll হয়েছে — এখন স্ক্যানে এই customer-কে পাওয়া যাবে',
      snackPosition: SnackPosition.BOTTOM,
    );
    if (error == null) await _load();
  }

  Future<void> _remove() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Face enroll মুছে ফেলবেন?'),
        content: const Text(
            'মুছে ফেললে স্ক্যানে আর এই customer-কে পাওয়া যাবে না। হিসাবের কোনো তথ্য মুছবে না।'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('না')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('মুছে ফেলুন')),
        ],
      ),
    );
    if (ok != true) return;
    await Get.find<FaceController>().removeEnrollment(widget.personId);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final e = _enrollment;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.face_retouching_natural),
            const SizedBox(width: 8),
            Text('ফেস আইডি', style: Theme.of(context).textTheme.titleMedium),
          ]),
          const SizedBox(height: 6),
          Text(e == null
              ? 'Face enroll করা নেই — enroll করলে ক্যামেরা স্ক্যানে এই customer-কে পাওয়া যাবে।'
              : '${e.samples.length}টি নমুনা enroll করা আছে (সর্বোচ্চ ${FaceEnrollment.maxSamples}টি)।'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _busy ? null : _enroll,
                icon: const Icon(Icons.camera_alt),
                label: Text(e == null ? 'Face enroll করুন' : 'আরেকটি নমুনা দিন'),
              ),
            ),
            if (e != null) ...[
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _busy ? null : _remove, child: const Text('মুছুন')),
            ],
          ]),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: LinearProgressIndicator(),
            ),
        ]),
      ),
    );
  }
}
