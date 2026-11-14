import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../persons/person_controller.dart';
import 'stage6_controller.dart';

/// Business reports (§15): period totals, module/category breakdown and
/// CSV export (copied to clipboard — share/save from any app).
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _period = 1; // 0 today, 1 this month, 2 this year

  Future<void> _applyPeriod() async {
    final c = Get.find<Stage6Controller>();
    final t = c.today.value;
    switch (_period) {
      case 0:
        await c.loadReport(from: t, to: t);
      case 2:
        await c.loadReport(from: DateTime.utc(t.year, 1, 1), to: DateTime.utc(t.year, 12, 31));
      default:
        await c.loadReportMonth();
    }
  }

  Future<void> _copyCsv(String csv, String label) async {
    await Clipboard.setData(ClipboardData(text: csv));
    Get.snackbar('কপি হয়েছে', '$label CSV clipboard-এ — যেকোনো জায়গায় paste করুন');
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<Stage6Controller>();
    final persons = Get.find<PersonController>();
    return Scaffold(
      appBar: AppBar(title: const Text('রিপোর্ট')),
      body: Obx(() {
        final r = c.report.value;
        return ListView(padding: const EdgeInsets.all(14), children: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('আজ')),
              ButtonSegment(value: 1, label: Text('এই মাস')),
              ButtonSegment(value: 2, label: Text('এই বছর')),
            ],
            selected: {_period},
            onSelectionChanged: (s) { setState(() => _period = s.first); _applyPeriod(); },
          ),
          const SizedBox(height: 12),
          if (r == null) const Center(child: CircularProgressIndicator()) else ...[
            _stat('মোট আয়', r.incomePoisha, AppColors.income),
            _stat('মোট খরচ', r.expensePoisha, AppColors.expense),
            _stat('লাভ / ক্ষতি', r.profitPoisha, r.profitPoisha >= 0 ? AppColors.income : AppColors.expense),
            _stat('কালেকশন (সমিতিসহ)', r.collectionPoisha, AppColors.primaryContainer),
            _stat('বাকি দেওয়া হয়েছে', r.bakiGivenPoisha, AppColors.due),
            _stat('বাকি ফেরত এসেছে', r.bakiReceivedPoisha, AppColors.statusAdvance),
            const SizedBox(height: 8),
            Text('খরচের বিভাগ', style: Theme.of(context).textTheme.titleMedium),
            if (r.expenseByCategory.isEmpty) const Text('এই সময়ে খরচ নেই'),
            ...r.expenseByCategory.entries.map((e) => Card(child: ListTile(
                  title: Text(e.key),
                  trailing: Text(formatBdt(e.value, banglaDigits: true), style: const TextStyle(fontWeight: FontWeight.w700)),
                ))),
            const SizedBox(height: 8),
            Text('আয়ের উৎস (মডিউল)', style: Theme.of(context).textTheme.titleMedium),
            ...r.incomeByModule.entries.map((e) => Card(child: ListTile(
                  title: Text(e.key),
                  trailing: Text(formatBdt(e.value, banglaDigits: true), style: const TextStyle(fontWeight: FontWeight.w700)),
                ))),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => _copyCsv(c.exportReportCsv(), 'রিপোর্ট'),
                icon: const Icon(Icons.download), label: const Text('রিপোর্ট CSV'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(
                onPressed: () async {
                  final nameOf = {for (final p in persons.persons) p.id: p.name};
                  _copyCsv(await c.exportEntriesCsv(nameOf), 'সব এন্ট্রি');
                },
                icon: const Icon(Icons.list_alt), label: const Text('এন্ট্রি CSV'))),
            ]),
          ],
          const SizedBox(height: 88),
        ]);
      }),
    );
  }

  Widget _stat(String label, int poisha, Color color) => Card(child: ListTile(
        title: Text(label),
        trailing: Text(formatBdt(poisha, banglaDigits: true),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color)),
      ));
}
