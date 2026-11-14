import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import 'auth_screen.dart';
import 'sync_controller.dart';

/// Sync status (§12): account, pending work, last sync, manual Sync Now.
class SyncStatusScreen extends StatelessWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SyncController>();
    return Scaffold(
      appBar: AppBar(title: const Text('সিঙ্ক ও অ্যাকাউন্ট')),
      body: Obx(() => ListView(padding: const EdgeInsets.all(14), children: [
            Card(child: ListTile(
              leading: const Icon(Icons.cloud_sync, color: AppColors.primaryContainer),
              title: Text(c.firebaseReady.value ? 'Firebase সংযুক্ত' : 'Firebase সেটআপ হয়নি'),
              subtitle: Text(c.email.value ?? 'লগইন করা নেই'),
              trailing: c.email.value == null
                  ? FilledButton.tonal(onPressed: () => Get.to(() => const AuthScreen()), child: const Text('লগইন'))
                  : TextButton(onPressed: () => c.signOut(), child: const Text('লগআউট')),
            )),
            const SizedBox(height: 8),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('অপেক্ষমাণ পরিবর্তন: ${c.pendingCount.value}টি',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text('অবস্থা: ${c.status.value}'),
                Text('সর্বশেষ সিঙ্ক: ${c.lastSyncAt.value == null ? 'এখনো হয়নি' : c.lastSyncAt.value.toString()}'),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, height: 50, child: FilledButton.icon(
                  onPressed: c.syncing.value
                      ? null
                      : () async {
                          final err = await c.syncNow();
                          if (err != null) Get.snackbar('সিঙ্ক হয়নি', err);
                        },
                  icon: const Icon(Icons.sync), label: const Text('এখনই সিঙ্ক করুন'))),
              ]))),
            const SizedBox(height: 8),
            const Text('সিঙ্ক ব্যর্থ হলেও লোকাল ডেটা কখনো মোছে না — পরে আবার চেষ্টা করলেই বাকি কাজ উঠে যাবে। '
                'একই রেকর্ড দুইবার ওঠে না (প্রতিটা অপারেশনের নির্দিষ্ট আইডি আছে)।',
                style: TextStyle(color: Colors.black54, fontSize: 12)),
          ])),
    );
  }
}
