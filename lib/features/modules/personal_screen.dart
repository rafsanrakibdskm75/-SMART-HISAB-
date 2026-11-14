import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../persons/person_controller.dart';
import 'module_controller.dart';

/// Personal Hisab (§10): completely separate from the business books.
class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  Future<void> _addEntry(BuildContext context, {required bool isExpense}) async {
    final amount = TextEditingController();
    final category = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
          title: Text(isExpense ? 'ব্যক্তিগত খরচ যোগ' : 'ব্যক্তিগত আয় যোগ'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
            const SizedBox(height: 8),
            TextField(controller: category, decoration: const InputDecoration(labelText: 'বিভাগ (যেমন: বাজার, যাতায়াত)')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('সেভ')),
          ]));
    if (ok == true) {
      try {
        await Get.find<ModuleController>().addPersonalEntry(
          isExpense: isExpense, amountPoisha: takaStringToPoisha(amount.text),
          category: category.text.trim().isEmpty ? 'অন্যান্য' : category.text.trim());
      } on FormatException {
        Get.snackbar('ভুল', 'সঠিক পরিমাণ দিন');
      }
    }
  }

  Future<void> _familyTransfer(BuildContext context) async {
    final persons = Get.find<PersonController>();
    final amount = TextEditingController();
    String? personId = persons.persons.isEmpty ? null : persons.persons.first.id;
    final ok = await showDialog<bool>(context: context, builder: (_) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('পরিবারে টাকা পাঠান'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                initialValue: personId, decoration: const InputDecoration(labelText: 'কার কাছে'),
                items: persons.persons.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => personId = v)),
              const SizedBox(height: 8),
              TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('পাঠান')),
            ])));
    if (ok == true && personId != null) {
      try {
        await Get.find<ModuleController>().familyTransfer(
            personId: personId!, amountPoisha: takaStringToPoisha(amount.text));
      } on FormatException {
        Get.snackbar('ভুল', 'সঠিক পরিমাণ দিন');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ModuleController>();
    return Scaffold(
      appBar: AppBar(title: const Text('ব্যক্তিগত হিসাব')),
      body: Obx(() {
        final s = c.personalSummary.value;
        return ListView(padding: const EdgeInsets.all(14), children: [
          Card(color: AppColors.primaryContainer, child: Padding(padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('এই মাস (শুধু ব্যক্তিগত)', style: TextStyle(color: Colors.white70)),
                Text('আয় ${formatBdt(s?.incomePoisha ?? 0, banglaDigits: true)} • খরচ ${formatBdt(s?.expensePoisha ?? 0, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white)),
                Text('অবশিষ্ট ${formatBdt(s?.netPoisha ?? 0, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              ]))),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: FilledButton.icon(onPressed: () => _addEntry(context, isExpense: true),
                icon: const Icon(Icons.remove_circle), label: const Text('খরচ যোগ'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(onPressed: () => _addEntry(context, isExpense: false),
                icon: const Icon(Icons.add_circle), label: const Text('আয় যোগ'))),
          ]),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: () => _familyTransfer(context),
              icon: const Icon(Icons.family_restroom), label: const Text('পরিবারে টাকা পাঠান')),
          const SizedBox(height: 14),
          Text('খরচের বিভাগ (এই মাস)', style: Theme.of(context).textTheme.titleMedium),
          if (s != null)
            ...s.expenseByCategory.entries.map((e) => Card(child: ListTile(
                  title: Text(e.key),
                  trailing: Text(formatBdt(e.value, banglaDigits: true),
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.expense)),
                ))),
          if (s == null || s.expenseByCategory.isEmpty) const Text('এই মাসে ব্যক্তিগত খরচ নেই'),
          const SizedBox(height: 8),
          const Text('ব্যক্তিগত হিসাব দোকানের Daily Hisab/ক্লোজিং-এ কখনো মেশে না।',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
        ]);
      }),
    );
  }
}
