import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../stage6/baki_screen.dart';
import '../stage6/reports_screen.dart';
import '../stage6/settings_screen.dart';
import '../sync/sync_status_screen.dart';
import 'mfs_dashboard_screen.dart';
import 'personal_screen.dart';
import 'recharge_screen.dart';
import 'somity_screen.dart';
import 'tokri_screen.dart';

/// সেবা hub (§7 quick actions): every Stage-4 module in one grid.
class ServicesHubScreen extends StatelessWidget {
  const ServicesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <(IconData, String, String, Color, Widget)>[
      (Icons.account_balance_wallet, 'মোবাইল ব্যাংকিং', 'বিকাশ • নগদ • রকেট • উপায়', AppColors.bkash, const MfsDashboardScreen()),
      (Icons.phone_android, 'মোবাইল রিচার্জ', 'সব অপারেটর • কমিশন হিসাব', AppColors.gp, const RechargeScreen()),
      (Icons.person, 'ব্যক্তিগত হিসাব', 'ব্যবসা থেকে সম্পূর্ণ আলাদা', AppColors.primaryContainer, const PersonalScreen()),
      (Icons.shopping_basket, 'টোকরি ভাড়া', 'হাজিরা অনুযায়ী ভাড়া', AppColors.due, const TokriScreen()),
      (Icons.groups, 'সমিতি', 'সদস্যদের সঞ্চয় আদায়', AppColors.rocket, const SomityScreen()),
      (Icons.cloud_sync, 'সিঙ্ক ও অ্যাকাউন্ট', 'ক্লাউড ব্যাকআপ • Firebase', AppColors.bank, const SyncStatusScreen()),
      (Icons.menu_book, 'বাকি খাতা', 'কাস্টমারের বকেয়া হিসাব', AppColors.due, const BakiScreen()),
      (Icons.bar_chart, 'রিপোর্ট', 'আয়-ব্যয়, লাভ, CSV export', AppColors.primaryContainer, const ReportsScreen()),
      (Icons.settings, 'সেটিংস ও ব্যাকআপ', 'প্রোফাইল, reminder, backup', AppColors.statusGrey, const SettingsScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('সেবা সমূহ')),
      body: GridView.count(
        crossAxisCount: 2, padding: const EdgeInsets.all(14), crossAxisSpacing: 12, mainAxisSpacing: 12,
        children: tiles.map((t) => Card(
              child: InkWell(
                onTap: () => Get.to(() => t.$5),
                child: Padding(padding: const EdgeInsets.all(14), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(backgroundColor: t.$4.withOpacity(0.15),
                        child: Icon(t.$1, color: t.$4)),
                    const SizedBox(height: 10),
                    Text(t.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(t.$3, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ])),
              ),
            )).toList(),
      ),
    );
  }
}
