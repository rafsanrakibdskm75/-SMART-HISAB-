/// Login screen (v1.1.3) — built in the splash's design system (the
/// re-export the owner sent contained only the splash screen, so this
/// screen is original work in the same Bengal Ledger Tactile system).
///
/// Offers: email + password, fingerprint unlock (when enabled on an
/// account and supported by the device), create-account, and the
/// offline continue that keeps the shop running without any account.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_colors.dart';
import '../home/home_shell.dart';
import 'auth_widgets.dart';
import 'create_account_screen.dart';
import 'session_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;
  bool _biometricReady = false;
  String? _error;

  SessionController get _session => Get.find<SessionController>();

  @override
  void initState() {
    super.initState();
    _email.text = _session.settings.value.accountEmail;
    _prepareBiometric();
  }

  Future<void> _prepareBiometric() async {
    await _session.load(); // fresh profile (may have changed since splash)
    if (!mounted) return;
    setState(() {}); // repaint the profile chip with fresh data
    final ready = _session.biometricOffered && await _session.biometricAvailable();
    if (!mounted) return;
    setState(() => _biometricReady = ready);
    if (ready) {
      // Banking-app pattern: offer the fingerprint right away; cancelling
      // simply leaves the password form.
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (mounted) _fingerprint();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goHome() => Get.offAll(() => const HomeShell());

  Future<void> _fingerprint() async {
    if (_busy) return; // never stack the prompt on a running login
    final ok = await _session.unlockWithBiometric();
    if (ok && mounted) _goHome();
  }

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final err = await _session.signIn(_email.text, _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    await maybeOfferBiometric();
    _goHome();
  }

  Future<void> _offline() async {
    await _session.continueOffline();
    _goHome();
  }

  @override
  Widget build(BuildContext context) {
    final s = _session.settings.value;
    return authScaffold(
      child: ListView(padding: const EdgeInsets.fromLTRB(24, 28, 24, 20), children: [
        const AuthHeader(subtitle: 'আপনার অ্যাকাউন্টে লগইন করুন'),
        const SizedBox(height: 22),
        if (_session.hasAccount)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F9F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              const Icon(Icons.storefront, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.businessName,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(s.accountEmail,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF5A6B60))),
                ]),
              ),
            ]),
          ),
        if (_session.hasAccount) const SizedBox(height: 18),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'ইমেইল', prefixIcon: Icon(Icons.email_outlined)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: 'পাসওয়ার্ড',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(_error!,
              style: const TextStyle(color: Color(0xFFDC4545), fontSize: 13)),
        ],
        const SizedBox(height: 18),
        FilledButton(
          onPressed: _busy ? null : _login,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _busy
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('লগইন করুন', style: TextStyle(fontSize: 16)),
          ),
        ),
        if (_biometricReady) ...[
          const SizedBox(height: 20),
          Center(
            child: Column(children: [
              InkWell(
                onTap: _fingerprint,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.6),
                    color: const Color(0xFFE8F9F1),
                  ),
                  child: const Icon(Icons.fingerprint,
                      size: 38, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Fingerprint দিয়ে খুলুন',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
        const SizedBox(height: 22),
        const Row(children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('অথবা', style: TextStyle(color: Color(0xFF5A6B60))),
          ),
          Expanded(child: Divider()),
        ]),
        const SizedBox(height: 14),
        OutlinedButton(
          onPressed: () => Get.to(() => const CreateAccountScreen()),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text('নতুন অ্যাকাউন্ট তৈরি করুন', style: TextStyle(fontSize: 15)),
          ),
        ),
        // No offline door when an account exists — it would bypass the
        // password gate (see SessionController.continueOffline).
        if (!_session.hasAccount)
          TextButton(
            onPressed: _offline,
            child: const Text('অফলাইনে চালিয়ে যান'),
          ),
      ]),
    );
  }
}
