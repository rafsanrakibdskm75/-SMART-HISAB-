import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../../domain/daily_ledger.dart';
import '../collection/collection_controller.dart';
import '../collection/receive_payment_screen.dart';
import '../persons/person_controller.dart';
import 'module_controller.dart';

/// Somity (§11): members save through the same per-day collection engine,
/// but the money is booked under the somity module — kept separate from
/// the shop's own collections (§14).
class SomityScreen extends StatelessWidget {
  const SomityScreen({super.key});

  Future<void> _addMember(BuildContext context) async {
    final persons = Get.find<PersonController>();
    final mc = Get.find<ModuleController>();
    final candidates = persons.persons.where((p) => !mc.somityMembers.contains(p.id)).toList();
    if (candidates.isEmpty) {
      Get.snackbar('সবাই ইতিমধ্যে সদস্য', 'আগে ব্যক্তি তালিকায় নতুন ব্যক্তি যোগ করুন');
      return;
    }
    await showModalBottomSheet(
      context: context,
      builder: (_) => ListView(children: candidates.map((p) => ListTile(
            leading: const Icon(Icons.person_add),
            title: Text(p.name), subtitle: Text(p.mobile ?? ''),
            onTap: () async { await mc.addSomityMember(p.id); Get.back(); },
          )).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<ModuleController>();
    final cc = Get.find<CollectionController>();
    final persons = Get.find<PersonController>();
    String nameOf(String id) {
      final m = persons.persons.where((p) => p.id == id);
      return m.isEmpty ? id : m.first.name;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('সমিতি')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMember(context), icon: const Icon(Icons.person_add), label: const Text('সদস্য যোগ')),
      body: Obx(() {
        var totalExpected = 0, totalReceived = 0;
        for (final id in mc.somityMembers) {
          final s = cc.summaries[id];
          if (s != null) {
            totalExpected += s.todayExpectedPoisha;
            totalReceived += s.todayReceivedPoisha;
          }
        }
        return ListView(padding: const EdgeInsets.all(14), children: [
          Card(color: AppColors.primaryContainer, child: Padding(padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('সমিতি — আজকের আদায়', style: TextStyle(color: Colors.white70)),
                Text('পেয়েছি ${formatBdt(totalReceived, banglaDigits: true)} / প্রত্যাশিত ${formatBdt(totalExpected, banglaDigits: true)}',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const Text('সমিতির টাকা দোকানের কালেকশন থেকে আলাদা খাতে থাকে',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]))),
          const SizedBox(height: 10),
          if (mc.somityMembers.isEmpty) const Text('এখনো কোনো সদস্য নেই'),
          ...mc.somityMembers.map((id) {
            final s = cc.summaries[id];
            final color = s == null
                ? AppColors.statusGrey
                : (s.todayExpectedPoisha > 0 && s.todayRemainingPoisha == 0)
                    ? AppColors.statusPaid
                    : (s.todayReceivedPoisha > 0 ? AppColors.statusPartial : AppColors.statusUnpaid);
            return Card(child: ListTile(
              leading: CircleAvatar(backgroundColor: color, child: const Icon(Icons.person, color: Colors.white)),
              title: Text(nameOf(id), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(s == null ? 'শিডিউল নেই' :
                  'আজ: ${formatBdt(s.todayReceivedPoisha, banglaDigits: true)} / ${formatBdt(s.todayExpectedPoisha, banglaDigits: true)}'
                  '${s.overduePoisha > 0 ? ' • বকেয়া ${formatBdt(s.overduePoisha, banglaDigits: true)}' : ''}'),
              trailing: FilledButton.tonal(
                onPressed: () => Get.to(() => ReceivePaymentScreen(
                    personId: id, personName: nameOf(id), ledgerModule: EntryModule.somity)),
                child: const Text('আদায়')),
            ));
          }),
          const SizedBox(height: 8),
          const Text('সদস্যের শিডিউল সেট করতে ব্যক্তি প্রোফাইল → কালেকশন → শিডিউল ব্যবহার করুন।',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 88),
        ]);
      }),
    );
  }
}
