/// Splash screen — the user's Stitch design `smart_hisab_splash_screen`
/// (delivered 2026-11-13) rebuilt in Flutter: light mint background,
/// FINTECH VERIFIED pill, logo, feature chips, loading bar and the
/// "Made With Md Nahidul Islam" footer. Shows briefly, then routes:
/// home for returning/offline users, login for the account gate.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../home/home_shell.dart';
import 'login_screen.dart';
import 'session_controller.dart';

/// Keep in step with pubspec `version:` at every release.
const String splashVersionLabel = '1.1.6';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final session = Get.find<SessionController>();
    await session.load();
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    if (session.decide() == GateDecision.home) {
      Get.offAll(() => const HomeShell());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  Widget _pill(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFD8E6DC)),
        ),
        child: child,
      );

  Widget _featureCard(IconData icon, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE1EFE6)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9F1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w600))),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFFDF3), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
            child: Column(children: [
              _pill(const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 8, color: AppColors.income),
                SizedBox(width: 7),
                Text('FINTECH VERIFIED • BD LEDGER',
                    style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ])),
              const Spacer(flex: 2),
              Container(
                width: 138,
                height: 138,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x33176B4D),
                        blurRadius: 24,
                        offset: Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset('assets/images/app_logo.png',
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 22),
              const Text('স্মার্ট হিসাব',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF121E18))),
              const SizedBox(height: 2),
              const Text('SMART HISAB',
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 8),
              const Text('ডিজিটাল হিসাব খাতা ও সহজ ব্যবসা পরিচালনা',
                  style: TextStyle(fontSize: 14.5, color: Color(0xFF5A6B60))),
              const SizedBox(height: 18),
              _pill(Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.lock, size: 15, color: AppColors.primary),
                const SizedBox(width: 7),
                Text('${toBanglaDigits('100')}% নিরাপদ ও সুরক্ষিত ক্লাউড ব্যাকআপ',
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w600)),
              ])),
              const SizedBox(height: 14),
              Row(children: [
                _featureCard(Icons.receipt_long, 'দৈনিক হিসাব\nখাতা ও ক্যাশবুক'),
                const SizedBox(width: 10),
                _featureCard(Icons.payments, 'তাত্ক্ষণিক রসিদ\nবিকাশ/নগদ লিংক'),
              ]),
              const Spacer(flex: 3),
              const SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  minHeight: 4,
                  color: AppColors.income,
                  backgroundColor: Color(0xFFDCEFE3),
                ),
              ),
              const SizedBox(height: 10),
              const Text('তথ্য লোড হচ্ছে...',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF5A6B60))),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('ভার্সন ${toBanglaDigits(splashVersionLabel)}  •  ',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF5A6B60))),
                const Icon(Icons.favorite, size: 13, color: Colors.red),
                const Text(' Made With Md Nahidul Islam',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ]),
              const SizedBox(height: 4),
              const Text('BANGLADESH SME DIGITAL LEDGER NETWORK',
                  style: TextStyle(
                      fontSize: 9.5,
                      letterSpacing: 1.6,
                      color: Color(0xFF8AA294))),
            ]),
          ),
        ),
      ),
    );
  }
}
