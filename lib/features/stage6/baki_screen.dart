import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../persons/person_controller.dart';
import 'stage6_controller.dart';

/// Baki Khata (§6 of the product spec): who owes the shop, how much, and
/// since when — payments settle the oldest dues first (FIFO).
class BakiScreen extends StatelessWidget {
  const BakiScreen({super.key});

  Future<void> _addEntry(BuildContext context, {required bool isPayment}) async {
    final persons = Get.find<PersonController>();
    if (persons.persons.isEmpty) {
      Get.snackbar('আগে ব্যক্তি যোগ করুন', 'বাকি দিতে একজন কাস্টমার লাগবে');
      return;
    }
    String personId = persons.persons.first.id;
    final amount = TextEditingController();
    final note = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (_) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(isPayment ? 'বাকি পরিশোধ নিন' : 'বাকি দিন'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                initialValue: personId, decoration: const InputDecoration(labelText: 'কাস্টমার'),
                items: persons.persons.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => personId = v ?? personId)),
              const SizedBox(height: 8),
              TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
              const SizedBox(height: 8),
              TextField(controller: note, decoration: const InputDecoration(labelText: 'নোট (কী কিনলেন?)')),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('সেভ')),
            ])));
    if (ok == true) {
      try {
        final err = await Get.find<Stage6Controller>().addBaki(
          personId: personId, amountPoisha: takaStringToPoisha(amount.text),
          isPayment: isPayment, note: note.text.trim().isEmpty ? null : note.text.trim());
        if (err != null) Get.snackbar('হয়নি', err);
      } on FormatException {
        Get.snackbar('ভুল', 'সঠিক পরিমাণ দিন');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<Stage6Controller>();
    final persons = Get.find<PersonController>();
    String nameOf(String id) {
      final m = persons.persons.where((p) => p.id == id);
      return m.isEmpty ? id : m.first.name;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('বাকি খাতা')),
      body: Obx(() => ListView(padding: const EdgeInsets.all(14), children: [
            Card(color: AppColors.due, child: Padding(padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('মোট বাকি (সব কাস্টমার)', style: TextStyle(color: Colors.white70)),
                  Text(formatBdt(c.totalDue.value, banglaDigits: true),
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                ]))),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: FilledButton.icon(onPressed: () => _addEntry(context, isPayment: false),
                  icon: const Icon(Icons.add_shopping_cart), label: const Text('বাকি দিন'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: () => _addEntry(context, isPayment: true),
                  icon: const Icon(Icons.payments), label: const Text('পরিশোধ নিন'))),
            ]),
            const SizedBox(height: 10),
            if (c.dueList.isEmpty) const Text('কারো কাছে বাকি নেই 🎉'),
            ...c.dueList.map((b) => Card(child: ListTile(
                  leading: const CircleAvatar(backgroundColor: AppColors.statusUnpaid,
                      child: Icon(Icons.person, color: Colors.white)),
                  title: Text(nameOf(b.personId), style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(b.oldestUnpaidDate == null ? '' :
                      'সবচেয়ে পুরনো বাকি: ${formatDateBn(b.oldestUnpaidDate!)} (${toBanglaDigits(b.daysOverdue.toString())} দিন)'),
                  trailing: Text(formatBdt(b.duePoisha, banglaDigits: true),
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.statusUnpaid, fontSize: 16)),
                ))),
          ])),
    );
  }
}
