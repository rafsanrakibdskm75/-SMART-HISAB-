import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/modules.dart';
import 'module_controller.dart';

/// MFS dashboard (§8): one balance card per provider account — balances
/// are recalculated from the ledger, never typed in (§14).
class MfsDashboardScreen extends StatelessWidget {
  const MfsDashboardScreen({super.key});

  static const _colors = <EntryModule, Color>{
    EntryModule.bkash: AppColors.bkash,
    EntryModule.nagad: AppColors.nagad,
    EntryModule.rocket: AppColors.rocket,
    EntryModule.upay: AppColors.upay,
    EntryModule.bank: AppColors.bank,
    EntryModule.cash: AppColors.primaryContainer,
  };

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ModuleController>();
    return Scaffold(
      appBar: AppBar(title: const Text('মোবাইল ব্যাংকিং')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const MfsTransferScreen()),
        icon: const Icon(Icons.swap_horiz), label: const Text('ট্রান্সফার')),
      body: Obx(() => ListView(padding: const EdgeInsets.all(14), children: [
            ...mfsProviders.entries.map((e) => Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: _colors[e.key]!.withOpacity(0.15),
                        child: Icon(Icons.account_balance_wallet, color: _colors[e.key])),
                    title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('ব্যালেন্স (খতিয়ান থেকে হিসাব করা)'),
                    trailing: Text(formatBdt(c.balances[e.key] ?? 0, banglaDigits: true),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    onTap: () => Get.to(() => MfsEntryScreen(provider: e.key)),
                  ),
                )),
            const SizedBox(height: 8),
            const Text('কোনো কার্ডে চাপ দিলে ওই অ্যাকাউন্টে ক্যাশ ইন / ক্যাশ আউট / পেমেন্ট যোগ করা যাবে।',
                style: TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 88),
          ])),
    );
  }
}

class MfsEntryScreen extends StatefulWidget {
  const MfsEntryScreen({super.key, required this.provider});
  final EntryModule provider;
  @override
  State<MfsEntryScreen> createState() => _MfsEntryScreenState();
}

class _MfsEntryScreenState extends State<MfsEntryScreen> {
  final _amount = TextEditingController();
  final _fee = TextEditingController();
  final _commission = TextEditingController();
  MfsTxType _type = MfsTxType.cashIn;
  String? _error;

  static const _typeNames = {
    MfsTxType.cashIn: 'ক্যাশ ইন (টাকা ঢুকল)', MfsTxType.cashOut: 'ক্যাশ আউট (টাকা বের হলো)',
    MfsTxType.sendMoney: 'সেন্ড মানি (পাঠালাম)', MfsTxType.payment: 'পেমেন্ট (দিলাম)',
    MfsTxType.receive: 'রিসিভ (পেলাম)',
  };

  @override
  void dispose() { _amount.dispose(); _fee.dispose(); _commission.dispose(); super.dispose(); }

  int _parse(TextEditingController t) => t.text.trim().isEmpty ? 0 : takaStringToPoisha(t.text);

  Future<void> _save() async {
    try {
      final amount = _parse(_amount);
      if (amount <= 0) { setState(() => _error = 'পরিমাণ দিন'); return; }
      final err = await Get.find<ModuleController>().mfsTx(
        provider: widget.provider, type: _type, amountPoisha: amount,
        feePoisha: _parse(_fee), commissionPoisha: _parse(_commission));
      if (err != null) { setState(() => _error = err); return; }
      Get.back();
    } on FormatException {
      setState(() => _error = 'সঠিক সংখ্যা দিন');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${mfsProviders[widget.provider]} — লেনদেন')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        DropdownButtonFormField<MfsTxType>(
          initialValue: _type, decoration: const InputDecoration(labelText: 'লেনদেনের ধরন'),
          items: _typeNames.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: (v) => setState(() => _type = v ?? MfsTxType.cashIn)),
        const SizedBox(height: 12),
        TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
        const SizedBox(height: 12),
        TextField(controller: _fee, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'ফি (যদি থাকে)')),
        const SizedBox(height: 12),
        TextField(controller: _commission, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'কমিশন আয় (যদি থাকে) — এটাই আসল লাভ')),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        SizedBox(height: 52, child: FilledButton(onPressed: _save, child: const Text('সংরক্ষণ করুন'))),
      ]),
    );
  }
}

class MfsTransferScreen extends StatefulWidget {
  const MfsTransferScreen({super.key});
  @override
  State<MfsTransferScreen> createState() => _MfsTransferScreenState();
}

class _MfsTransferScreenState extends State<MfsTransferScreen> {
  EntryModule _from = EntryModule.bkash;
  EntryModule _to = EntryModule.cash;
  final _amount = TextEditingController();
  String? _error;

  @override
  void dispose() { _amount.dispose(); super.dispose(); }

  Future<void> _save() async {
    try {
      final amount = takaStringToPoisha(_amount.text);
      final err = await Get.find<ModuleController>().transfer(from: _from, to: _to, amountPoisha: amount);
      if (err != null) { setState(() => _error = err); return; }
      Get.back();
      Get.snackbar('ট্রান্সফার হয়েছে', 'নিজের অ্যাকাউন্টের মধ্যে — মোট ব্যালেন্স বদলায়নি');
    } on FormatException {
      setState(() => _error = 'সঠিক পরিমাণ দিন');
    }
  }

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<EntryModule> item(MapEntry<EntryModule, String> e) =>
        DropdownMenuItem(value: e.key, child: Text(e.value));
    return Scaffold(
      appBar: AppBar(title: const Text('অ্যাকাউন্ট ট্রান্সফার')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        DropdownButtonFormField<EntryModule>(
          initialValue: _from, decoration: const InputDecoration(labelText: 'কোন অ্যাকাউন্ট থেকে'),
          items: mfsProviders.entries.map(item).toList(),
          onChanged: (v) => setState(() => _from = v ?? _from)),
        const SizedBox(height: 12),
        DropdownButtonFormField<EntryModule>(
          initialValue: _to, decoration: const InputDecoration(labelText: 'কোন অ্যাকাউন্টে'),
          items: mfsProviders.entries.map(item).toList(),
          onChanged: (v) => setState(() => _to = v ?? _to)),
        const SizedBox(height: 12),
        TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        SizedBox(height: 52, child: FilledButton(onPressed: _save, child: const Text('ট্রান্সফার করুন'))),
      ]),
    );
  }
}
