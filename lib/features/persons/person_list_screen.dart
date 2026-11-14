import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import 'person_controller.dart';
import 'person_form_screen.dart';
import 'person_profile_screen.dart';
import '../face/face_scan_screen.dart';

/// Person directory (Stitch: baki_customer_ledger / person_directory).
/// Search by name, mobile or ID (§7). Large touch targets, Bangla first (§17).
class PersonListScreen extends StatelessWidget {
  const PersonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PersonController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ব্যক্তি ও কাস্টমার'),
        actions: [
          IconButton(
            icon: const Icon(Icons.face_retouching_natural),
            tooltip: 'ফেস স্ক্যান',
            onPressed: () => Get.to(() => const FaceScanScreen()),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
          child: TextField(
            onChanged: (v) => c.query.value = v,
            decoration: const InputDecoration(
              hintText: 'নাম, মোবাইল বা আইডি দিয়ে খুঁজুন',
              prefixIcon: Icon(Icons.search)),
          ),
        ),
        Obx(() {
          if (c.duplicateGroups.isEmpty) return const SizedBox.shrink();
          final strong = c.duplicateGroups.where((g) => g.sameMobile).length;
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.brown),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  strong > 0
                      ? '${c.duplicateGroups.length}টি নামে মিল আছে ($strongটি-তে মোবাইলও এক) — একই লোক দুইবার খোলা থাকলে বাকি/কালেকশন ভাগ হয়ে যাবে। যাচাই করে একটা মুছে দিন।'
                      : '${c.duplicateGroups.length}টি নামে মিল আছে — একই লোক দুইবার খোলা থাকলে বাকি/কালেকশন ভাগ হয়ে যাবে। যাচাই করে একটা মুছে দিন।',
                  style: const TextStyle(color: Colors.brown),
                )),
              ]),
            ),
          );
        }),
        Expanded(child: Obx(() {
          if (c.loading.value) return const Center(child: CircularProgressIndicator());
          if (c.persons.isEmpty) {
            return const Center(child: Text('কোনো ব্যক্তি নেই — + চাপ দিয়ে যোগ করুন'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: c.persons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final p = c.persons[i];
              final dup = c.duplicateIds.contains(p.id);
              return Card(child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(p.name.isEmpty ? '?' : p.name[0],
                      style: const TextStyle(color: Colors.white))),
                title: Text(p.name),
                subtitle: Text(dup
                    ? '⚠ সম্ভাব্য duplicate • ${p.mobile ?? p.id}'
                    : (p.mobile ?? p.id)),
                trailing: dup
                    ? const Icon(Icons.warning_amber_rounded, color: Colors.amber)
                    : const Icon(Icons.chevron_right),
                onTap: () => Get.to(() => PersonProfileScreen(person: p)),
              ));
            },
          );
        })),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const PersonFormScreen()),
        icon: const Icon(Icons.person_add), label: const Text('নতুন ব্যক্তি')),
    );
  }
}
