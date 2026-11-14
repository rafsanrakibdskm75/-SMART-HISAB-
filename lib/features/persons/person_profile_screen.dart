import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/ledger_service.dart';
import '../../domain/person.dart';
import '../collection/person_collection_screen.dart';
import '../collection/schedule_form_screen.dart';
import '../face/face_enrollment_section.dart';

/// Person profile + full statement (Stitch: customer_profile_statement).
/// Statement lines come from personStatement() with a running balance;
/// corrections are reversals, never edits (§14).
class PersonProfileScreen extends StatelessWidget {
  const PersonProfileScreen({super.key, required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final ledger = Get.find<LedgerRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: FutureBuilder<List<LedgerEntry>>(
        future: ledger.all(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final statement = personStatement(snap.data!, person.id);
          final net = statement.isEmpty ? 0 : statement.last.runningPoisha;
          return ListView(padding: const EdgeInsets.all(14), children: [
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(person.name, style: Theme.of(context).textTheme.titleLarge),
                if (person.mobile != null) Text(person.mobile!),
                const SizedBox(height: 8),
                Text('নিট ব্যালেন্স: ${formatBdt(net, banglaDigits: true)}',
                    style: TextStyle(
                        color: net >= 0 ? const Color(0xFF16A36A) : const Color(0xFFDC4545),
                        fontWeight: FontWeight.w600)),
              ]))),
            const SizedBox(height: 10),
            FaceEnrollmentSection(personId: person.id),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: FilledButton.icon(
                onPressed: () => Get.to(() => PersonCollectionScreen(personId: person.id, personName: person.name)),
                icon: const Icon(Icons.collections_bookmark), label: const Text('কালেকশন'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(
                onPressed: () => Get.to(() => ScheduleFormScreen(personId: person.id, personName: person.name)),
                icon: const Icon(Icons.schedule), label: const Text('শিডিউল যোগ'))),
            ]),
            const SizedBox(height: 8),
            Text('পাকা খতিয়ান বিবরণী', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...statement.map((line) => Card(child: ListTile(
                  title: Text(line.entry.note ?? line.entry.category ?? line.entry.module.name),
                  subtitle: Text(formatDateBn(line.entry.date)),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      '${line.entry.direction == EntryDirection.in_ ? '+' : '-'}${formatBdt(line.entry.amountPoisha, banglaDigits: true)}',
                      style: TextStyle(color: line.entry.direction == EntryDirection.in_
                          ? const Color(0xFF16A36A) : const Color(0xFFDC4545))),
                    Text('ব্যালেন্স ${formatBdt(line.runningPoisha, banglaDigits: true)}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ))),
            if (statement.isEmpty) const Text('এখনো কোনো লেনদেন নেই'),
            const SizedBox(height: 88),
          ]);
        },
      ),
    );
  }
}
