import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/money.dart';
import '../../domain/stage6.dart';
import 'stage6_controller.dart';
import '../auth/session_controller.dart';

/// Settings + backup (§16): business profile, reminder preferences,
/// full-data backup export and restore.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _business = TextEditingController();
  final _owner = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();
  final _threshold = TextEditingController();
  final _commission = TextEditingController();
  bool _reminder = true;
  bool _loaded = false;

  @override
  void dispose() {
    for (final c in [_business, _owner, _mobile, _address, _threshold, _commission]) { c.dispose(); }
    super.dispose();
  }

  void _fill(AppSettings s) {
    if (_loaded) return;
    _loaded = true;
    _business.text = s.businessName;
    _owner.text = s.ownerName;
    _mobile.text = s.mobile;
    _address.text = s.address;
    _threshold.text = (s.lowStockThresholdPoisha / 100).toStringAsFixed(0);
    _commission.text = (s.defaultRechargeCommissionBp / 100).toString();
    _reminder = s.dailyClosingReminder;
  }

  Future<void> _save() async {
    final c = Get.find<Stage6Controller>();
    final old = c.settings.value;
    try {
      await c.saveSettings(old.copyWith(
        businessName: _business.text.trim().isEmpty ? old.businessName : _business.text.trim(),
        ownerName: _owner.text.trim(), mobile: _mobile.text.trim(), address: _address.text.trim(),
        lowStockThresholdPoisha: takaStringToPoisha(_threshold.text),
        defaultRechargeCommissionBp: ((double.tryParse(_commission.text) ?? 2.8) * 100).round(),
        dailyClosingReminder: _reminder));
      Get.snackbar('সেভ হয়েছে', 'সেটিংস আপডেট হয়েছে');
    } on FormatException {
      Get.snackbar('ভুল', 'সংখ্যা ঠিক করে দিন');
    }
  }

  Future<void> _export() async {
    final c = Get.find<Stage6Controller>();
    final backup = c.exportBackup();
    await Clipboard.setData(ClipboardData(text: backup));
    Get.snackbar('ব্যাকআপ কপি হয়েছে', 'এই লেখাটা নিরাপদ জায়গায় রেখে দিন — এটাই পুরো ডেটার ব্যাকআপ');
  }

  Future<void> _import() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
          title: const Text('ব্যাকআপ Restore'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('সাবধান: বর্তমান সব ডেটা ব্যাকআপের ডেটা দিয়ে বদলে যাবে।'),
            const SizedBox(height: 8),
            TextField(controller: ctrl, maxLines: 4, decoration: const InputDecoration(labelText: 'ব্যাকআপের লেখা paste করুন')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restore করুন')),
          ]));
    if (ok == true) {
      final err = Get.find<Stage6Controller>().importBackup(ctrl.text.trim());
      Get.snackbar(err == null ? 'Restore হয়েছে ✅' : 'Restore হয়নি', err ?? 'ডেটা ফিরে এসেছে');
      if (err == null) setState(() => _loaded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<Stage6Controller>();
    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস ও ব্যাকআপ')),
      body: Obx(() {
        _fill(c.settings.value);
        return ListView(padding: const EdgeInsets.all(14), children: [
          TextField(controller: _business, decoration: const InputDecoration(labelText: 'দোকানের নাম')),
          const SizedBox(height: 10),
          TextField(controller: _owner, decoration: const InputDecoration(labelText: 'মালিকের নাম')),
          const SizedBox(height: 10),
          TextField(controller: _mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'মোবাইল')),
          const SizedBox(height: 10),
          TextField(controller: _address, decoration: const InputDecoration(labelText: 'ঠিকানা')),
          const SizedBox(height: 10),
          TextField(controller: _threshold, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'রিচার্জ স্টক সতর্কতা (৳) — এর নিচে গেলে reminder')),
          const SizedBox(height: 10),
          TextField(controller: _commission, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'ডিফল্ট রিচার্জ কমিশন %')),
          SwitchListTile(
            title: const Text('প্রতিদিন হিসাব বন্ধের reminder'),
            subtitle: Text('রাত ${toBanglaDigits(c.settings.value.closingReminderHour.toString())}:${toBanglaDigits(c.settings.value.closingReminderMinute.toString().padLeft(2, '0'))} টায়'),
            value: _reminder, onChanged: (v) => setState(() => _reminder = v)),
          SizedBox(height: 50, child: FilledButton(onPressed: _save, child: const Text('সেটিংস সেভ করুন'))),
          // v1.1.3 — fingerprint unlock toggle (account থাকলেই দেখায়)
          Builder(builder: (context) {
            final session = Get.find<SessionController>();
            if (!session.hasAccount) return const SizedBox.shrink();
            return Obx(() => SwitchListTile(
                  secondary: const Icon(Icons.fingerprint),
                  title: const Text('Fingerprint login'),
                  subtitle: const Text('পরের বার পাসওয়ার্ড ছাড়া fingerprint দিয়ে app খুলুন'),
                  value: session.settings.value.biometricEnabled,
                  onChanged: (v) async {
                    if (v && !await session.biometricAvailable()) {
                      Get.snackbar('পাওয়া যায়নি',
                          'এই ফোনে fingerprint/Face ID setup করা নেই — আগে ফোনের Settings থেকে চালু করুন',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    await session.setBiometricEnabled(v);
                  },
                ));
          }),
          const Divider(height: 32),
          Text('আজকের Reminder', style: Theme.of(context).textTheme.titleMedium),
          if (c.reminders.isEmpty) const Text('আজ কোনো reminder নেই 🎉'),
          ...c.reminders.map((r) => Card(child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: Text(r.title), subtitle: Text(r.body),
                trailing: IconButton(icon: const Icon(Icons.send),
                    onPressed: () => c.notifications.showNow(r)),
              ))),
          const Divider(height: 32),
          SizedBox(height: 50, child: OutlinedButton.icon(onPressed: _export,
              icon: const Icon(Icons.backup), label: const Text('ব্যাকআপ নিন (copy)'))),
          const SizedBox(height: 8),
          SizedBox(height: 50, child: OutlinedButton.icon(onPressed: _import,
              icon: const Icon(Icons.restore), label: const Text('ব্যাকআপ Restore করুন'))),
          const SizedBox(height: 88),
        ]);
      }),
    );
  }
}
