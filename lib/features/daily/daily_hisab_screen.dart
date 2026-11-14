import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../domain/daily_ledger.dart';
import 'add_entry_screen.dart';
import 'daily_controller.dart';

/// Daily Hisab ledger (Stitch: daily_hisab_ledger). Opening comes from
/// yesterday's closing; closing never deletes history (§2).
class DailyHisabScreen extends StatelessWidget {
  const DailyHisabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DailyController>();
    return Scaffold(
      appBar: AppBar(title: const Text('দৈনিক হিসাব'), actions: [
        IconButton(icon: const Icon(Icons.chevron_left),
            onPressed: () => c.setDate(addDays(c.date.value, -1))),
        IconButton(icon: const Icon(Icons.chevron_right),
            onPressed: () => c.setDate(addDays(c.date.value, 1))),
      ]),
      body: Obx(() {
        final s = c.summary.value;
        return ListView(padding: const EdgeInsets.all(14), children: [
          Text(formatDateBn(c.date.value), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (s != null)
            Card(color: AppColors.primaryContainer, child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ওপেনিং: ${formatBdt(s.openingPoisha, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white70)),
                Text('ক্লোজিং ব্যালেন্স: ${formatBdt(s.closingPoisha, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(children: [
                  Text('↑ জমা ${formatBdt(s.totalInPoisha, banglaDigits: true)}',
                      style: const TextStyle(color: Color(0xFF9AE9C3))),
                  const SizedBox(width: 16),
                  Text('↓ খরচ ${formatBdt(s.totalOutPoisha, banglaDigits: true)}',
                      style: const TextStyle(color: Color(0xFFFFCDCA))),
                ]),
                Text('কালেকশন: ${formatBdt(s.collectionPoisha, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white70)),
              ]))),
          const SizedBox(height: 8),
          if (c.closed.value)
            Card(child: ListTile(
              leading: const Icon(Icons.lock, color: AppColors.due),
              title: const Text('এই দিন বন্ধ (closed)'),
              subtitle: const Text('নতুন এন্ট্রি দিতে আগে কারণ দিয়ে রিওপেন করুন'),
              trailing: TextButton(
                onPressed: () async {
                  final reason = await _askReason(context);
                  if (reason != null && reason.isNotEmpty) {
                    await c.reopenDay('owner', reason);
                  }
                },
                child: const Text('রিওপেন')),
            ))
          else
            OutlinedButton.icon(
              onPressed: () => c.closeDay('owner'),
              icon: const Icon(Icons.lock_open), label: const Text('দিন বন্ধ করুন (Daily Closing)')),
          const SizedBox(height: 8),
          ...c.entries.map((e) => Card(child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: e.direction == EntryDirection.in_
                      ? AppColors.income.withOpacity(0.12) : AppColors.expense.withOpacity(0.12),
                  child: Icon(
                    e.direction == EntryDirection.in_ ? Icons.arrow_downward : Icons.arrow_upward,
                    color: e.direction == EntryDirection.in_ ? AppColors.income : AppColors.expense, size: 18)),
                title: Text(e.note ?? e.category ?? e.module.name),
                subtitle: Text('${e.module.name}${e.isReversal ? ' • রিভার্সাল' : ''}'),
                trailing: Text(
                  '${e.direction == EntryDirection.in_ ? '+' : '-'}${formatBdt(e.amountPoisha, banglaDigits: true)}',
                  style: TextStyle(
                      color: e.direction == EntryDirection.in_ ? AppColors.income : AppColors.expense,
                      fontWeight: FontWeight.w600)),
                onLongPress: () async {
                  final err = await c.reverse(e);
                  if (err != null) {
                    Get.snackbar('হয়নি', err);
                  } else {
                    Get.snackbar('রিভার্সাল হয়েছে', 'আসল এন্ট্রি অপরিবর্তিত আছে, নতুন রিভার্সাল এন্ট্রি যোগ হয়েছে');
                  }
                },
              ))),
          if (c.entries.isEmpty) const Center(child: Padding(
              padding: EdgeInsets.all(24), child: Text('এই দিনে কোনো লেনদেন নেই'))),
          const SizedBox(height: 88),
        ]);
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddEntryScreen()),
        icon: const Icon(Icons.add), label: const Text('+ লেনদেন')),
    );
  }

  Future<String?> _askReason(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('রিওপেনের কারণ'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'কারণ লিখুন (অডিট লগে থাকবে)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('রিওপেন')),
        ],
      ),
    );
  }
}
