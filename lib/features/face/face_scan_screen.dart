/// Face scan verification (Stitch screen #19, v1.1.0): point the camera
/// at a customer, the app finds their record. A match is a finder only —
/// the staff member sees who matched and taps through themselves; no
/// money ever moves from a scan alone.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/face_recognition.dart';
import '../../domain/person.dart';
import '../collection/person_collection_screen.dart';
import '../persons/person_profile_screen.dart';
import 'face_capture_screen.dart';
import 'face_controller.dart';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  bool _busy = false;
  FaceIdentifyResult? _result;

  String _pct(double score) =>
      toBanglaDigits('${(score * 100).toStringAsFixed(1)}%');

  Future<void> _scan() async {
    final path = await Get.to<String>(() => const FaceCaptureScreen());
    if (path == null || !mounted) return;
    setState(() {
      _busy = true;
      _result = null;
    });
    final result = await Get.find<FaceController>().identifyFromPhoto(path);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _result = result;
    });
  }

  Widget _personCard(Person p, double score, {bool primary = false}) {
    final ledger = Get.find<LedgerRepository>();
    return Card(
      color: primary ? AppColors.surface : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.verified_user, color: Color(0xFF16A36A)),
            const SizedBox(width: 8),
            Expanded(
                child: Text(p.name,
                    style: Theme.of(context).textTheme.titleLarge)),
            Chip(label: Text('মিল ${_pct(score)}')),
          ]),
          if (p.mobile != null) Text(p.mobile!),
          FutureBuilder<int>(
            future: ledger.personNet(p.id),
            builder: (context, snap) {
              if (!snap.hasData) return const SizedBox.shrink();
              final net = snap.data!;
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  net < 0
                      ? 'বাকি পাওনা: ${formatBdt(-net, banglaDigits: true)}'
                      : 'কোনো বাকি নেই',
                  style: TextStyle(
                      color: net < 0
                          ? const Color(0xFFDC4545)
                          : const Color(0xFF16A36A),
                      fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: OutlinedButton(
              onPressed: () => Get.to(() => PersonProfileScreen(person: p)),
              child: const Text('প্রোফাইল'),
            )),
            const SizedBox(width: 8),
            Expanded(
                child: FilledButton(
              onPressed: () => Get.to(() =>
                  PersonCollectionScreen(personId: p.id, personName: p.name)),
              child: const Text('কালেকশন'),
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _resultView(FaceIdentifyResult r) {
    if (r.errorMessage != null && r.status == null) {
      return _messageCard(Icons.error_outline, r.errorMessage!, Colors.red);
    }
    switch (r.status) {
      case FaceMatchStatus.matched:
        return Column(children: [
          _messageCard(Icons.check_circle, 'গ্রাহক সফলভাবে সনাক্ত হয়েছে',
              const Color(0xFF16A36A)),
          _personCard(r.person!, r.score, primary: true),
        ]);
      case FaceMatchStatus.ambiguous:
        return Column(children: [
          _messageCard(Icons.help_outline,
              'দুজনের সাথে কাছাকাছি মিলেছে — সঠিক জনকে বেছে নিন', Colors.orange),
          _personCard(r.person!, r.score),
          _personCard(r.secondPerson!, r.secondScore),
        ]);
      case FaceMatchStatus.noMatch:
        return _messageCard(
            Icons.person_search,
            r.errorMessage ?? 'কোনো মিল পাওয়া যায়নি — তালিকা থেকে খুঁজে নিন',
            Colors.orange);
      case null:
        return const SizedBox.shrink();
    }
  }

  Widget _messageCard(IconData icon, String text, Color color) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('স্মার্ট ফেস আইডি ভেরিফিকেশন')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Text(
                'Customer-এর মুখের ছবি তুলুন — যার face enroll করা আছে তাকে খুঁজে তার হিসাব খুলে দেবে। '
                'মিল শুধু খোঁজার জন্য; টাকা নেওয়ার আগে নিজে যাচাই করে নিন।'),
          ),
        ),
        const SizedBox(height: 12),
        if (_busy)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ))
        else if (_result != null)
          _resultView(_result!),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _busy ? null : _scan,
          icon: const Icon(Icons.camera_alt),
          label: Text(_result == null ? 'ক্যামেরা দিয়ে স্ক্যান করুন' : 'আবার স্ক্যান করুন'),
        ),
      ]),
    );
  }
}
