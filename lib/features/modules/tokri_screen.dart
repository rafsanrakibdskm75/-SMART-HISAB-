import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/id_gen.dart';
import '../../core/money.dart';
import '../../domain/modules.dart';
import '../persons/person_controller.dart';
import 'module_controller.dart';

/// Tokri Vara (§11): rent follows attendance — present days charge,
/// absent/leave days charge nothing.
class TokriScreen extends StatelessWidget {
  const TokriScreen({super.key});

  Future<void> _addRental(BuildContext context) async {
    final persons = Get.find<PersonController>();
    if (persons.persons.isEmpty) {
      Get.snackbar('আগে ব্যক্তি যোগ করুন', 'ভাড়াটে হিসেবে একজন ব্যক্তি লাগবে');
      return;
    }
    String personId = persons.persons.first.id;
    final count = TextEditingController(text: '10');
    final rate = TextEditingController(text: '40');
    final ok = await showDialog<bool>(context: context, builder: (_) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('নতুন টোকরি ভাড়া'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                initialValue: personId, decoration: const InputDecoration(labelText: 'ভাড়াটে'),
                items: persons.persons.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => personId = v ?? personId)),
              const SizedBox(height: 8),
              TextField(controller: count, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'টোকরির সংখ্যা')),
              const SizedBox(height: 8),
              TextField(controller: rate, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'প্রতিদিন প্রতি টোকরি ভাড়া (৳)')),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('সেভ')),
            ])));
    if (ok == true) {
      try {
        await Get.find<ModuleController>().saveRental(TokriRental(
          id: IdGen.next('tokri'), personId: personId,
          tokriCount: int.parse(count.text), dailyRatePoisha: takaStringToPoisha(rate.text)));
      } catch (_) {
        Get.snackbar('ভুল', 'সংখ্যা ঠিক করে দিন');
      }
    }
  }

  Future<void> _collect(BuildContext context, TokriRental rental, String name) async {
    final amount = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
          title: Text('$name — ভাড়া আদায়'),
          content: TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('আদায়')),
          ]));
    if (ok == true) {
      try {
        await Get.find<ModuleController>().collectRent(rental, takaStringToPoisha(amount.text));
      } on FormatException {
        Get.snackbar('ভুল', 'সঠিক পরিমাণ দিন');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ModuleController>();
    final persons = Get.find<PersonController>();
    String nameOf(String id) {
      final m = persons.persons.where((p) => p.id == id);
      return m.isEmpty ? id : m.first.name;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('টোকরি ভাড়া')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addRental(context), icon: const Icon(Icons.add), label: const Text('নতুন ভাড়া')),
      body: Obx(() => ListView(padding: const EdgeInsets.all(14), children: [
            if (c.rentals.isEmpty) const Text('এখনো কোনো ভাড়া নেই — নিচের বোতামে যোগ করুন'),
            ...c.rentals.map((r) => Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(nameOf(r.personId),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                      Chip(label: Text('এই মাসে বাকি ${formatBdt(c.monthDue[r.id] ?? 0, banglaDigits: true)}',
                          style: const TextStyle(color: AppColors.statusUnpaid, fontWeight: FontWeight.w700))),
                    ]),
                    Text('${toBanglaDigits(r.tokriCount.toString())} টোকরি × ${formatBdt(r.dailyRatePoisha, banglaDigits: true)}/দিন'),
                    const SizedBox(height: 8),
                    const Text('আজকের হাজিরা:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Wrap(spacing: 6, children: [
                      ChoiceChip(label: const Text('উপস্থিত'), selected: c.todayAttendance[r.id] == AttendanceStatus.present,
                          onSelected: (_) => c.markAttendance(r.id, AttendanceStatus.present)),
                      ChoiceChip(label: const Text('অনুপস্থিত'), selected: c.todayAttendance[r.id] == AttendanceStatus.absent,
                          onSelected: (_) => c.markAttendance(r.id, AttendanceStatus.absent)),
                      ChoiceChip(label: const Text('ছুটি'), selected: c.todayAttendance[r.id] == AttendanceStatus.leave,
                          onSelected: (_) => c.markAttendance(r.id, AttendanceStatus.leave)),
                    ]),
                    Align(alignment: Alignment.centerRight,
                        child: FilledButton.tonal(onPressed: () => _collect(context, r, nameOf(r.personId)),
                            child: const Text('ভাড়া আদায়'))),
                  ])))),
            const SizedBox(height: 88),
          ])),
    );
  }
}
