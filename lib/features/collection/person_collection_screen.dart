import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../domain/collection_engine.dart';
import '../../domain/collection_models.dart';
import 'collection_controller.dart';
import 'receive_payment_screen.dart';
import 'schedule_form_screen.dart';

/// One person's collection home (§3): today's expected/received/remaining,
/// every missed date on its own line, upcoming days, payment history,
/// schedule actions (edit / pause / holiday).
class PersonCollectionScreen extends StatelessWidget {
  const PersonCollectionScreen({super.key, required this.personId, required this.personName});
  final String personId;
  final String personName;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CollectionController>();
    return Scaffold(
      appBar: AppBar(title: Text('$personName — কালেকশন')),
      body: FutureBuilder(
        future: Future.wait([c.obligationsOf(personId), c.paymentsOf(personId), c.schedulesOf(personId)]),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final obs = snap.data![0] as List<CollectionObligation>;
          final payments = snap.data![1] as List<CollectionPayment>;
          final schedules = snap.data![2] as List<CollectionSchedule>;
          final today = c.today.value;
          final s = summarizePerson(obs, today: today);
          final upcoming = obs.where((o) => o.date.isAfter(today)).take(7).toList();
          return ListView(padding: const EdgeInsets.all(14), children: [
            Card(color: AppColors.primaryContainer, child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('আজ প্রত্যাশিত: ${formatBdt(s.todayExpectedPoisha, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white70)),
                Text('আজ পেয়েছি: ${formatBdt(s.todayReceivedPoisha, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                Text('আজ বাকি: ${formatBdt(s.todayRemainingPoisha, banglaDigits: true)}',
                    style: const TextStyle(color: Color(0xFFFFCDCA))),
                if (s.overduePoisha > 0) ...[
                  const SizedBox(height: 8),
                  Chip(backgroundColor: AppColors.statusUnpaid,
                      label: Text('বকেয়া ${formatBdt(s.overduePoisha, banglaDigits: true)}',
                          style: const TextStyle(color: Colors.white))),
                ],
              ]))),
            const SizedBox(height: 10),
            Wrap(spacing: 8, children: [
              FilledButton.icon(
                onPressed: () => Get.to(() => ReceivePaymentScreen(personId: personId, personName: personName)),
                icon: const Icon(Icons.payments), label: const Text('টাকা গ্রহণ')),
              OutlinedButton.icon(
                onPressed: () => Get.to(() => ScheduleFormScreen(personId: personId, personName: personName)),
                icon: const Icon(Icons.schedule), label: const Text('শিডিউল')),
              OutlinedButton.icon(
                onPressed: () async {
                  await c.markHoliday(personId, holiday: true);
                  Get.snackbar('ছুটি', 'আজকের দিন ছুটি হিসেবে চিহ্নিত হয়েছে');
                },
                icon: const Icon(Icons.beach_access), label: const Text('আজ ছুটি')),
            ]),
            if (schedules.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...schedules.map((sch) => Card(child: ListTile(
                    title: Text('প্রতিদিন/শিডিউল: ${formatBdt(sch.expectedPoisha, banglaDigits: true)} • ${sch.type.name}'),
                    subtitle: Text('শুরু: ${formatDateBn(sch.startDate)} • কার্যকর: ${formatDateBn(sch.effectiveFrom)}${sch.paused ? ' • ⏸ বন্ধ আছে' : ''}'),
                    trailing: TextButton(
                      onPressed: () => c.setPaused(sch.id, paused: !sch.paused),
                      child: Text(sch.paused ? 'চালু করুন' : 'বন্ধ রাখুন')),
                  ))),
            ],
            if (s.overdueItems.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('বকেয়া দিনগুলো (আলাদা আলাদা)', style: Theme.of(context).textTheme.titleMedium),
              ...s.overdueItems.map((o) => Card(child: ListTile(
                    leading: const Icon(Icons.error, color: AppColors.statusUnpaid),
                    title: Text(formatDateBn(o.date)),
                    subtitle: Text('প্রত্যাশিত ${formatBdt(o.expectedPoisha, banglaDigits: true)} • পেয়েছি ${formatBdt(o.paidPoisha, banglaDigits: true)}'),
                    trailing: Text(formatBdt(o.remainingPoisha, banglaDigits: true),
                        style: const TextStyle(color: AppColors.statusUnpaid, fontWeight: FontWeight.w700)),
                  ))),
            ],
            if (upcoming.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('আসন্ন দিন', style: Theme.of(context).textTheme.titleMedium),
              ...upcoming.map((o) => Card(child: ListTile(
                    title: Text(formatDateBn(o.date)),
                    trailing: Text(o.isHoliday ? 'ছুটি' : formatBdt(o.expectedPoisha, banglaDigits: true)),
                  ))),
            ],
            const SizedBox(height: 12),
            Text('পেমেন্ট ইতিহাস', style: Theme.of(context).textTheme.titleMedium),
            ...payments.map((p) => Card(child: ListTile(
                  title: Text(formatBdt(p.amountPoisha, banglaDigits: true)),
                  subtitle: Text('${formatDateBn(p.date)} • ${p.method}'),
                ))),
            if (payments.isEmpty) const Text('এখনো কোনো পেমেন্ট নেই'),
            const SizedBox(height: 88),
          ]);
        },
      ),
    );
  }
}
