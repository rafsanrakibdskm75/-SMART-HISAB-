import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings.dart';
import 'data/sync/firebase_gate.dart';
import 'app/theme.dart';
import 'features/auth/splash_screen.dart';

/// Smart Hisab entry point. The app must start and work with NO network and
/// NO Firebase (§9) — Stage 5 initialization is guarded: any failure (or a
/// not-yet-configured project) leaves the app fully offline-capable.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseGate.init();
  runApp(const SmartHisabApp());
}

class SmartHisabApp extends StatelessWidget {
  const SmartHisabApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'স্মার্ট হিসাব',
      debugShowCheckedModeBanner: false,
      theme: smartHisabTheme(),
      initialBinding: AppBindings(),
      home: const SplashScreen(),
    );
  }
}
