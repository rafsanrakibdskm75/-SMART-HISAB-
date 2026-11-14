import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import 'collection_controller.dart';
import 'overdue_screen.dart';
import 'person_collection_screen.dart';
import 'receive_payment_screen.dart';

/// আজকের আদায় — Today's Collection (§7), live from CollectionRepository.
/// Previous overdue is always shown separately from today's expected (§8).
class TodayCollectionScreen extends StatelessWidget {
  const TodayCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CollectionController>();
    return Scaffold(
      appBar: AppBar(title: const Text('আজকের আদায়'), actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: c.load),
      ]),
      body: Obx(() {
        if (c.loading.value) return const Center(child: CircularProgressIndicator());
        final d = c.dashboard.value;
        if (d == null || (d.paidPersonIds.isEmpty && d.partialPersonIds.isEmpty && d.unpaidPersonIds.isEmpty)) {
          return const Center(child: Padding(padding: EdgeInsets.all(24),
            child: Text('আজ কোনো কালেকশন শিডিউল নেই।\nব্যক্তি তালিকা থেকে কারো প্রোফাইলে গিয়ে কালেকশন শিডিউল যোগ করুন।',
                textAlign: TextAlign.center)));
        }
        return ListView(padding: const EdgeInsets.all(14), children: [
          Text(formatDateBn(c.today.value), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(color: AppColors.primaryContainer, child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('মোট প্রত্যাশিত: ${formatBdt(d.totalExpectedPoisha, banglaDigits: true)}',
                  style: const TextStyle(color: Colors.white70)),
              Text('আদায়: ${formatBdt(d.totalReceivedPoisha, banglaDigits: true)}',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              Text('আজ বাকি: ${formatBdt(d.totalRemainingPoisha, banglaDigits: true)}',
                  style: const TextStyle(color: Color(0xFFFFCDCA))),
            ]))),
          if (d.totalOverduePoisha > 0)
            Card(color: AppColors.statusUnpaid, child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.white),
              title: Text('আগের বকেয়া: ${formatBdt(d.totalOverduePoisha, banglaDigits: true)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: const Text('আজকের হিসাবের সাথে মেশানো হয়নি', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () => Get.to(() => const OverdueScreen()),
            )),
          _section(context, c, 'পরিশোধ করেছেন', d.paidPersonIds, AppColors.statusPaid),
          _section(context, c, 'আংশিক পরিশোধ', d.partialPersonIds, AppColors.statusPartial),
          _section(context, c, 'পরিশোধ করেননি', d.unpaidPersonIds, AppColors.statusUnpaid),
          const SizedBox(height: 88),
        ]);
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickPerson(context, c),
        icon: const Icon(Icons.add), label: const Text('টাকা গ্রহণ')),
    );
  }

  Widget _section(BuildContext context, CollectionController c, String title, List<String> ids, Color color) {
    if (ids.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color))),
      ...ids.map((id) {
        final s = c.summaries[id];
        return Card(child: ListTile(
          title: Text(c.names[id] ?? id),
          subtitle: s == null ? null : Text(
              'প্রত্যাশিত ${formatBdt(s.todayExpectedPoisha, banglaDigits: true)} • পেয়েছি ${formatBdt(s.todayReceivedPoisha, banglaDigits: true)}'
              '${s.overduePoisha > 0 ? ' • বকেয়া ${formatBdt(s.overduePoisha, banglaDigits: true)}' : ''}'
              '${s.lastPaymentDate != null ? '\nশেষ পেমেন্ট: ${formatDateBn(s.lastPaymentDate!)}' : ''}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.payments, color: AppColors.primaryContainer),
                tooltip: 'টাকা গ্রহণ',
                onPressed: () => Get.to(() => ReceivePaymentScreen(personId: id, personName: c.names[id] ?? id))),
            IconButton(icon: const Icon(Icons.list_alt),
                tooltip: 'কালেকশন বিবরণ',
                onPressed: () => Get.to(() => PersonCollectionScreen(personId: id, personName: c.names[id] ?? id))),
          ]),
          onTap: () => Get.to(() => PersonCollectionScreen(personId: id, personName: c.names[id] ?? id)),
        ));
      }),
    ]);
  }

  void _pickPerson(BuildContext context, CollectionController c) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: c.allPersons.map((p) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(p.name),
              subtitle: Text(p.mobile ?? ''),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => ReceivePaymentScreen(personId: p.id, personName: p.name));
              },
            )).toList(),
      ),
    );
  }
}
