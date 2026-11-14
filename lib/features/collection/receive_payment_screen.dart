import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../domain/collection_models.dart';
import '../../domain/daily_ledger.dart';
import 'collection_controller.dart';

/// Receive Payment (§5, §7 quick action). The owner picks WHICH day this
/// money settles: today, one exact overdue date, or an advance for the next
/// scheduled day. Money is never auto-spread across days (§4).
class ReceivePaymentScreen extends StatefulWidget {
  const ReceivePaymentScreen({super.key, required this.personId, required this.personName, this.ledgerModule = EntryModule.collection});
  final String personId;
  final String personName;
  final EntryModule ledgerModule; // Somity passes EntryModule.somity (§14 separation)
  @override
  State<ReceivePaymentScreen> createState() => _ReceivePaymentScreenState();
}

class _ReceivePaymentScreenState extends State<ReceivePaymentScreen> {
  final _amount = TextEditingController();
  String _method = 'cash';
  DateTime? _targetDate; // null = today
  bool _targetPicked = false;
  List<CollectionObligation> _obligations = [];
  String? _error;

  static const _methods = [
    ('cash', 'নগদ ক্যাশ', AppColors.primaryContainer),
    ('bkash', 'বিকাশ', AppColors.bkash),
    ('nagad', 'নগদ', AppColors.nagad),
    ('rocket', 'রকেট', AppColors.rocket),
    ('upay', 'উপায়', AppColors.upay),
    ('bank', 'ব্যাংক', AppColors.bank),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = Get.find<CollectionController>();
    final obs = await c.obligationsOf(widget.personId);
    if (mounted) setState(() => _obligations = obs);
  }

  @override
  void dispose() { _amount.dispose(); super.dispose(); }

  Future<void> _save() async {
    int poisha;
    try {
      poisha = takaStringToPoisha(_amount.text);
    } on FormatException {
      setState(() => _error = 'সঠিক টাকার পরিমাণ দিন');
      return;
    }
    final c = Get.find<CollectionController>();
    final (result, err) = await c.receive(
      personId: widget.personId, amountPoisha: poisha,
      method: _method, targetDate: _targetPicked ? _targetDate : null,
      ledgerModule: widget.ledgerModule);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    if (!mounted) return;
    final r = result!;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('পেমেন্ট গৃহীত হয়েছে ✅'),
        content: Text(
            'প্রয়োগ হয়েছে: ${formatBdt(r.appliedPoisha, banglaDigits: true)}\n'
            '${r.advanceCreditPoisha > 0 ? 'অতিরিক্ত (অগ্রিম জমা): ${formatBdt(r.advanceCreditPoisha, banglaDigits: true)}\n' : ''}'
            'স্ট্যাটাস: ${_statusName(r.statusAfter)}'),
        actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('ঠিক আছে'))],
      ),
    );
    if (mounted) Get.back();
  }

  String _statusName(CollectionStatus s) => switch (s) {
        CollectionStatus.paid => 'সম্পূর্ণ পরিশোধ (সবুজ)',
        CollectionStatus.partial => 'আংশিক পরিশোধ (হলুদ)',
        CollectionStatus.unpaid => 'অপরিশোধিত (লাল)',
        CollectionStatus.advance => 'অগ্রিম পরিশোধ (নীল)',
        CollectionStatus.notScheduled => 'শিডিউল নেই (ধূসর)',
      };

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CollectionController>();
    final today = c.today.value;
    final overdue = _obligations.where((o) => o.isOverdue(today: today)).toList();
    final future = _obligations.where((o) => o.date.isAfter(today) && !o.isFullyPaid && !o.isHoliday).toList();
    return Scaffold(
      appBar: AppBar(title: Text('${widget.personName} — টাকা গ্রহণ')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
        const SizedBox(height: 14),
        const Text('মাধ্যম', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, children: _methods.map((m) => ChoiceChip(
              label: Text(m.$2),
              selected: _method == m.$1,
              selectedColor: m.$3.withOpacity(0.2),
              onSelected: (_) => setState(() => _method = m.$1),
            )).toList()),
        const SizedBox(height: 14),
        const Text('কোন দিনের হিসাবে জমা হবে?', style: TextStyle(fontWeight: FontWeight.w600)),
        RadioListTile<bool>(
          value: false, groupValue: _targetPicked,
          title: Text('আজকের হিসাব (${formatDateBn(today)})'),
          onChanged: (_) => setState(() => _targetPicked = false),
        ),
        ...overdue.map((o) => RadioListTile<bool>(
              value: true, groupValue: _targetPicked && _targetDate == o.date,
              title: Text('বকেয়া দিন: ${formatDateBn(o.date)} — বাকি ${formatBdt(o.remainingPoisha, banglaDigits: true)}'),
              onChanged: (_) => setState(() { _targetPicked = true; _targetDate = o.date; }),
            )),
        if (future.isNotEmpty)
          RadioListTile<bool>(
            value: true, groupValue: _targetPicked && _targetDate == future.first.date,
            title: Text('অগ্রিম: ${formatDateBn(future.first.date)}'),
            onChanged: (_) => setState(() { _targetPicked = true; _targetDate = future.first.date; }),
          ),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        SizedBox(height: 52, child: FilledButton(onPressed: _save, child: const Text('পেমেন্ট সংরক্ষণ করুন'))),
      ]),
    );
  }
}
