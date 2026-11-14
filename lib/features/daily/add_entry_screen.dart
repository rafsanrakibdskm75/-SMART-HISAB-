import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/money.dart';
import '../../domain/daily_ledger.dart';
import 'daily_controller.dart';

/// Income / expense entry — one tap, numeric keyboard, exact poisha parsing.
class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});
  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  EntryDirection _direction = EntryDirection.in_;
  EntryModule _module = EntryModule.dailyHisab;
  String? _error;

  @override
  void dispose() { _amount.dispose(); _note.dispose(); super.dispose(); }

  Future<void> _save() async {
    int poisha;
    try {
      poisha = takaStringToPoisha(_amount.text);
    } on FormatException {
      setState(() => _error = 'সঠিক টাকার পরিমাণ দিন');
      return;
    }
    if (poisha <= 0) {
      setState(() => _error = 'পরিমাণ ০-এর বেশি হতে হবে');
      return;
    }
    final c = Get.find<DailyController>();
    final err = await c.addEntry(
      direction: _direction, amountPoisha: poisha, module: _module,
      category: _direction == EntryDirection.in_ ? 'আয়' : 'খরচ',
      note: _note.text.isEmpty ? null : _note.text);
    if (err != null) {
      setState(() => _error = err);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন লেনদেন')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        SegmentedButton<EntryDirection>(
          segments: const [
            ButtonSegment(value: EntryDirection.in_, label: Text('জমা / আয়')),
            ButtonSegment(value: EntryDirection.out_, label: Text('খরচ')),
          ],
          selected: {_direction},
          onSelectionChanged: (s) => setState(() => _direction = s.first),
        ),
        const SizedBox(height: 14),
        TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'পরিমাণ (৳)', prefixText: '৳ ')),
        const SizedBox(height: 12),
        DropdownButtonFormField<EntryModule>(
          initialValue: _module,
          decoration: const InputDecoration(labelText: 'মডিউল'),
          items: const [
            DropdownMenuItem(value: EntryModule.dailyHisab, child: Text('দৈনিক হিসাব')),
            DropdownMenuItem(value: EntryModule.income, child: Text('আয়')),
            DropdownMenuItem(value: EntryModule.expense, child: Text('ব্যয়')),
            DropdownMenuItem(value: EntryModule.baki, child: Text('বাকি')),
            DropdownMenuItem(value: EntryModule.cash, child: Text('ক্যাশ')),
            DropdownMenuItem(value: EntryModule.personal, child: Text('ব্যক্তিগত')),
          ],
          onChanged: (v) => setState(() => _module = v ?? EntryModule.dailyHisab),
        ),
        const SizedBox(height: 12),
        TextField(controller: _note, decoration: const InputDecoration(labelText: 'নোট')),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 20),
        SizedBox(height: 52, child: FilledButton(onPressed: _save, child: const Text('সংরক্ষণ করুন'))),
      ]),
    );
  }
}
