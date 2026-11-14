import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import 'sync_controller.dart';

/// Login / register (§13). The app works fully without an account —
/// an account is only needed to sync and back up to the cloud.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    setState(() { _busy = true; _error = null; });
    final c = Get.find<SyncController>();
    final err = _register
        ? await c.register(_email.text, _password.text)
        : await c.signIn(_email.text, _password.text);
    setState(() => _busy = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      Get.back();
      Get.snackbar('স্বাগতম', 'লগইন হয়েছে — এখন সিঙ্ক করা যাবে');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SyncController>();
    return Scaffold(
      appBar: AppBar(title: const Text('অ্যাকাউন্ট')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (!c.firebaseReady.value)
          const Card(color: Color(0xFFFFF3E0), child: Padding(padding: EdgeInsets.all(12),
              child: Text('⚠️ Firebase এখনো সেটআপ হয়নি। অ্যাপ অফলাইনে পুরোপুরি চলবে — '
                  'সিঙ্ক চালু করতে docs/FIREBASE_SETUP.md-এর ধাপগুলো শেষ করুন।'))),
        const SizedBox(height: 8),
        TextField(controller: _email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'ইমেইল')),
        const SizedBox(height: 10),
        TextField(controller: _password, obscureText: true,
            decoration: const InputDecoration(labelText: 'পাসওয়ার্ড (কমপক্ষে ৬ অক্ষর)')),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 10),
            child: Text(_error!, style: const TextStyle(color: AppColors.error))),
        const SizedBox(height: 16),
        SizedBox(height: 52, child: FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(_busy ? 'অপেক্ষা করুন…' : (_register ? 'অ্যাকাউন্ট খুলুন' : 'লগইন করুন')))),
        TextButton(
          onPressed: () => setState(() => _register = !_register),
          child: Text(_register ? 'ইতিমধ্যে অ্যাকাউন্ট আছে? লগইন করুন' : 'নতুন অ্যাকাউন্ট খুলতে চান? এখানে চাপ দিন')),
        const SizedBox(height: 8),
        const Text('অ্যাকাউন্ট শুধু ক্লাউড ব্যাকআপ/সিঙ্কের জন্য। অ্যাকাউন্ট ছাড়াও প্রতিদিনের সব কাজ অফলাইনে চলবে।',
            style: TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
    );
  }
}
