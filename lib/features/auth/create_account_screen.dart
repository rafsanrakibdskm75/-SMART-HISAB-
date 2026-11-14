/// Create account screen (v1.1.3) — same design system as login/splash.
/// Without Firebase configured this creates the local profile (the shop
/// never waits on the cloud); with Firebase it registers the same email
/// there too, so sync keeps one identity.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_shell.dart';
import 'auth_widgets.dart';
import 'session_controller.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _business = TextEditingController();
  final _owner = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_business, _owner, _mobile, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final session = Get.find<SessionController>();
    final err = await session.createAccount(
      businessName: _business.text,
      ownerName: _owner.text,
      mobile: _mobile.text,
      email: _email.text,
      password: _password.text,
      confirmPassword: _confirm.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    await maybeOfferBiometric();
    Get.offAll(() => const HomeShell());
  }

  Widget _field(TextEditingController c, String label, IconData icon,
          {TextInputType? type, bool obscure = false, Widget? suffix}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          keyboardType: type,
          obscureText: obscure,
          decoration: InputDecoration(
              labelText: label, prefixIcon: Icon(icon), suffixIcon: suffix),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return authScaffold(
      child: ListView(padding: const EdgeInsets.fromLTRB(24, 20, 24, 20), children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        const AuthHeader(subtitle: 'নতুন অ্যাকাউন্ট তৈরি করুন'),
        const SizedBox(height: 22),
        _field(_business, 'বিজনেসের নাম', Icons.storefront),
        _field(_owner, 'আপনার নাম', Icons.person_outline),
        _field(_mobile, 'মোবাইল নম্বর', Icons.phone_outlined,
            type: TextInputType.phone),
        _field(_email, 'ইমেইল', Icons.email_outlined,
            type: TextInputType.emailAddress),
        _field(_password, 'পাসওয়ার্ড', Icons.lock_outline,
            obscure: !_showPassword,
            suffix: IconButton(
              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            )),
        _field(_confirm, 'পাসওয়ার্ড আবার দিন', Icons.lock_outline,
            obscure: !_showPassword),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(_error!,
                style: const TextStyle(color: Color(0xFFDC4545), fontSize: 13)),
          ),
        FilledButton(
          onPressed: _busy ? null : _create,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _busy
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('অ্যাকাউন্ট তৈরি করুন', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'ইন্টারনেট ছাড়াই অ্যাকাউন্ট তৈরি হয়ে যাবে — হিসাব সবসময় এই ফোনেই থাকে। '
          'Cloud sync চালু হলে একই ইমেইলেই সব পাওয়া যাবে।',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: Color(0xFF5A6B60)),
        ),
      ]),
    );
  }
}
