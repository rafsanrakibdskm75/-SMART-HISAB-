import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/money.dart';
import '../../domain/modules.dart';
import 'module_controller.dart';

/// Mobile recharge (§9): operator stock, sale with commission, history.
class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});
  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  String _operator = telecomOperators.first;
  final _number = TextEditingController();
  final _amount = TextEditingController();
  final _rate = TextEditingController(text: '2.8'); // % commission
  String? _error;

  static const _opColors = {
    'Grameenphone': AppColors.gp, 'Robi': AppColors.robi, 'Airtel': AppColors.airtel,
    'Banglalink': AppColors.banglalink, 'Teletalk': AppColors.teletalk,
  };

  @override
  void dispose() { _number.dispose(); _amount.dispose(); _rate.dispose(); super.dispose(); }

  Future<void> _setBalance() async {
    final ctrl = TextEditingController();
    final c = Get.find<ModuleController>();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
          title: Text('$_operator স্টক ব্যালেন্স সেট করুন'),
          content: TextField(controller: ctrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'ব্যালেন্স (৳)', prefixText: '৳ ')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('বাতিল')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('সেভ')),
          ]));
    if (ok == true) {
      try {
        await c.setOperatorBalance(_operator, takaStringToPoisha(ctrl.text));
      } on FormatException {
        setState(() => _error = 'সঠিক ব্যালেন্স দিন');
      }
    }
  }

  Future<void> _recharge() async {
    final c = Get.find<ModuleController>();
    try {
      final amount = takaStringToPoisha(_amount.text);
      final bp = ((double.tryParse(_rate.text) ?? 0) * 100).round(); // % -> basis points
      final (record, err) = await c.doRecharge(
          operator: _operator, number: _number.text.trim(), amountPoisha: amount, commissionBasisPoints: bp);
      if (err != null) { setState(() => _error = err); return; }
      setState(() => _error = null);
      Get.snackbar('রিচার্জ সফল ✅',
          'কমিশন আয়: ${formatBdt(record!.commissionPoisha, banglaDigits: true)}');
      _amount.clear();
    } on FormatException {
      setState(() => _error = 'সঠিক পরিমাণ দিন');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ModuleController>();
    return Scaffold(
      appBar: AppBar(title: const Text('মোবাইল রিচার্জ')),
      body: Obx(() => ListView(padding: const EdgeInsets.all(14), children: [
            Wrap(spacing: 8, children: telecomOperators.map((op) => ChoiceChip(
                  label: Text('${telecomOperatorsBn[op]} ${formatBdt(c.operatorBalances[op] ?? 0, banglaDigits: true)}'),
                  selected: _operator == op,
                  selectedColor: _opColors[op]!.withOpacity(0.2),
                  onSelected: (_) => setState(() => _operator = op),
                )).toList()),
            Align(alignment: Alignment.centerRight,
                child: TextButton(onPressed: _setBalance, child: const Text('অপারেটর ব্যালেন্স সেট করুন'))),
            TextField(controller: _number, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'মোবাইল নম্বর')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'রিচার্জ পরিমাণ (৳)', prefixText: '৳ '))),
              const SizedBox(width: 10),
              SizedBox(width: 110, child: TextField(controller: _rate,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'কমিশন %', suffixText: '%'))),
            ]),
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 14),
            SizedBox(height: 52, child: FilledButton(onPressed: _recharge, child: const Text('রিচার্জ করুন'))),
            const SizedBox(height: 16),
            Text('সাম্প্রতিক রিচার্জ', style: Theme.of(context).textTheme.titleMedium),
            ...c.recentRecharges.map((r) => Card(child: ListTile(
                  title: Text('${r.number} • ${telecomOperatorsBn[r.operator] ?? r.operator}'),
                  subtitle: Text('কমিশন ${formatBdt(r.commissionPoisha, banglaDigits: true)}'),
                  trailing: Text(formatBdt(r.amountPoisha, banglaDigits: true),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ))),
          ])),
    );
  }
}
