import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../domain/overdue.dart';
import 'collection_controller.dart';
import 'person_collection_screen.dart';

/// Global overdue list (§8) — প্রতিটি বকেয়া তারিখ আলাদা, badge: বকেয়া ৳X.
class OverdueScreen extends StatelessWidget {
  const OverdueScreen({super.key});

  String _kindLabel(OverdueKind k) => switch (k) {
        OverdueKind.oneDay => 'একদিনের বকেয়া',
        OverdueKind.multiDay => 'একাধিক দিনের বকেয়া',
        OverdueKind.partial => 'আংশিক পরিশোধ বাকি',
        OverdueKind.longOverdue => 'দীর্ঘদিনের বকেয়া',
      };

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CollectionController>();
    return Scaffold(
      appBar: AppBar(title: const Text('বকেয়া তালিকা')),
      body: Obx(() {
        if (c.overdueList.isEmpty) {
          return const Center(child: Text('কারো কোনো বকেয়া নেই 🎉'));
        }
        return ListView(padding: const EdgeInsets.all(14), children: [
          ...c.overdueList.map((o) => Card(child: ListTile(
                title: Row(children: [
                  Expanded(child: Text(c.names[o.personId] ?? o.personId)),
                  Chip(backgroundColor: AppColors.statusUnpaid,
                      label: Text('বকেয়া ${formatBdt(o.totalPoisha, banglaDigits: true)}',
                          style: const TextStyle(color: Colors.white))),
                ]),
                subtitle: Text(
                    '${_kindLabel(o.kind)} • মিস ${o.missedDays} দিন • সবচেয়ে পুরনো: ${o.items.isEmpty ? '' : formatDateBn(o.items.first.date)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.to(() => PersonCollectionScreen(
                    personId: o.personId, personName: c.names[o.personId] ?? o.personId)),
              ))),
          const SizedBox(height: 88),
        ]);
      }),
    );
  }
}
