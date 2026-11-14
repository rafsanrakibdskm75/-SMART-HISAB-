import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/ledger_service.dart';

/// Daily / Monthly / Yearly summaries (§2) — history is never reset.
class DailyHistoryScreen extends StatelessWidget {
  const DailyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final daily = Get.find<DailyRepository>();
    final ledger = Get.find<LedgerRepository>();
    final today = dhakaToday();
    return Scaffold(
      appBar: AppBar(title: const Text('হিসাবের ইতিহাস')),
      body: FutureBuilder(
        future: Future.wait([daily.history(from: addDays(today, -30), to: today), ledger.all()]),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final days = snap.data![0] as List<DailySummary>;
          final entries = snap.data![1] as List<LedgerEntry>;
          final month = monthlySummary(entries, today.year, today.month);
          final year = yearlySummary(entries, today.year);
          return ListView(padding: const EdgeInsets.all(14), children: [
            Card(child: ListTile(
              title: const Text('এই মাসের সারাংশ'),
              subtitle: Text('এন্ট্রি: ${month.entryCount}'),
              trailing: Text(formatBdt(month.netPoisha, banglaDigits: true),
                  style: const TextStyle(fontWeight: FontWeight.w700)))),
            Card(child: ListTile(
              title: const Text('এই বছরের সারাংশ'),
              subtitle: Text('কালেকশন: ${formatBdt(year.collectionPoisha, banglaDigits: true)}'),
              trailing: Text(formatBdt(year.netPoisha, banglaDigits: true),
                  style: const TextStyle(fontWeight: FontWeight.w700)))),
            const SizedBox(height: 10),
            Text('দৈনিক ইতিহাস (গত ৩০ দিন)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...days.map((d) => Card(child: ListTile(
                  title: Text(formatDateBn(d.date)),
                  subtitle: Text('জমা ${formatBdt(d.totalInPoisha, banglaDigits: true)} • খরচ ${formatBdt(d.totalOutPoisha, banglaDigits: true)}'),
                  trailing: Text(formatBdt(d.closingPoisha, banglaDigits: true),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ))),
            if (days.isEmpty) const Text('কোনো ইতিহাস নেই'),
            const SizedBox(height: 88),
          ]);
        },
      ),
    );
  }
}
