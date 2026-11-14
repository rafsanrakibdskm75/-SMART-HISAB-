/// Shared pieces for the auth screens (v1.1.3).
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'session_controller.dart';

/// After a successful password login / account creation: if this device
/// can do biometrics and the owner hasn't enabled fingerprint unlock
/// yet, offer it once. Returns after the choice is stored.
Future<void> maybeOfferBiometric() async {
  final session = Get.find<SessionController>();
  if (session.settings.value.biometricEnabled) return;
  if (!await session.biometricAvailable()) return;
  final enable = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Fingerprint login চালু করবেন?'),
      content: const Text(
          'চালু করলে পরের বার পাসওয়ার্ড না দিয়ে fingerprint / Face ID দিয়েই app খুলতে পারবেন।'),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('পরে')),
        FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('চালু করুন')),
      ],
    ),
  );
  if (enable == true) await session.setBiometricEnabled(true);
}

/// Small logo + app name header used by login / create screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.subtitle});
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 86,
        height: 86,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
                color: Color(0x26176B4D), blurRadius: 16, offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset('assets/images/app_logo.png', fit: BoxFit.cover),
        ),
      ),
      const SizedBox(height: 14),
      const Text('স্মার্ট হিসাব',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(subtitle,
          style: const TextStyle(fontSize: 14, color: Color(0xFF5A6B60))),
    ]);
  }
}

/// Light mint background shared with the splash design.
Widget authScaffold({required Widget child}) => Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFFDF3), Colors.white],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
