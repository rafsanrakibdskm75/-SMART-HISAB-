import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/dhaka_time.dart';
import '../../core/money.dart';
import '../../domain/collection_models.dart';
import 'collection_controller.dart';

/// Collection schedule setup (§6). Saving creates a NEW version effective
/// from the chosen date — আগের দিনের হিসাব কখনো বদলায় না।
class ScheduleFormScreen extends StatefulWidget {
  const ScheduleFormScreen({super.key, required this.personId, required this.personName});
  final String personId;
  final String personName;
  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _amount = TextEditingController();
  ScheduleType _type = ScheduleType.daily;
  final Set<int> _weekdays = {};
  DateTime _start = dhakaToday();
  DateTime _effective = dhakaToday();
  bool _allowAdvance = true;
  String? _error;

  static const _dayNames = {1: 'সোম', 2: 'মঙ্গল', 3: 'বুধ', 4: 'বৃহস্পতি', 5: 'শুক্র', 6: 'শনি', 7: 'রবি'};

  @override
  void dispose() { _amount.dispose(); super.dispose(); }

  Future<DateTime?> _pick(DateTime initial) => showDatePicker(
        context: context, initialDate: initial,
        firstDate: DateTime(2020), lastDate: DateTime(2035));

  Future<void> _save() async {
    int poisha;
    try {
      poisha = takaStringToPoisha(_amount.text);
    } on FormatException {
      setState(() => _error = 'সঠিক পরিমাণ দিন');
      return;
    }
    if (poisha <= 0) { setState(() => _error = 'পরিমাণ ০-এর বেশি হতে হবে'); return; }
    if ((_type == ScheduleType.weekly || _type == ScheduleType.custom) && _weekdays.isEmpty) {
      setState(() => _error = 'অন্তত একটি দিন বেছে নিন');
      return;
    }
    final c = Get.find<CollectionController>();
    final err = await c.saveSchedule(
      personId: widget.personId, expectedPoisha: poisha, type: _type,
      startDate: _start, effectiveFrom: _effective,
      weekdays: _weekdays,
      dayOfMonth: _type == ScheduleType.monthly ? _start.day : null,
      allowAdvance: _allowAdvance);
    if (err != null) {
      setState(() => _error = err);
    } else {
      Get.back();
      Get.snackbar('শিডিউল সেভ হয়েছে', 'কার্যকর: ${formatDateBn(_effective)} থেকে — আগের হিসাব অপরিবর্তিত');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.personName} — কালেকশন শিডিউল')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'প্রত্যাশিত পরিমাণ (৳)', prefixText: '৳ ')),
        const SizedBox(height: 12),
        DropdownButtonFormField<ScheduleType>(
          initialValue: _type,
          decoration: const InputDecoration(labelText: 'শিডিউলের ধরন'),
          items: const [
            DropdownMenuItem(value: ScheduleType.daily, child: Text('প্রতিদিন')),
            DropdownMenuItem(value: ScheduleType.weekly, child: Text('সাপ্তাহিক (নির্দিষ্ট দিন)')),
            DropdownMenuItem(value: ScheduleType.monthly, child: Text('মাসিক')),
            DropdownMenuItem(value: ScheduleType.yearly, child: Text('বার্ষিক')),
            DropdownMenuItem(value: ScheduleType.custom, child: Text('কাস্টম দিন')),
          ],
          onChanged: (v) => setState(() => _type = v ?? ScheduleType.daily),
        ),
        if (_type == ScheduleType.weekly || _type == ScheduleType.custom) ...[
          const SizedBox(height: 10),
          Wrap(spacing: 6, children: _dayNames.entries.map((e) => FilterChip(
                label: Text(e.value), selected: _weekdays.contains(e.key),
                onSelected: (sel) => setState(() => sel ? _weekdays.add(e.key) : _weekdays.remove(e.key)),
              )).toList()),
        ],
        const SizedBox(height: 12),
        ListTile(
          title: const Text('শুরুর তারিখ'),
          trailing: Text(formatDateBn(_start)),
          onTap: () async { final d = await _pick(_start); if (d != null) setState(() => _start = DateTime.utc(d.year, d.month, d.day)); },
        ),
        ListTile(
          title: const Text('কার্যকর তারিখ (পরিবর্তন হলে)'),
          subtitle: const Text('এই তারিখের আগের হিসাব বদলাবে না'),
          trailing: Text(formatDateBn(_effective)),
          onTap: () async { final d = await _pick(_effective); if (d != null) setState(() => _effective = DateTime.utc(d.year, d.month, d.day)); },
        ),
        SwitchListTile(
          title: const Text('অগ্রিম পেমেন্ট নেওয়া যাবে'),
          value: _allowAdvance,
          onChanged: (v) => setState(() => _allowAdvance = v),
        ),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        SizedBox(height: 52, child: FilledButton(onPressed: _save, child: const Text('শিডিউল সংরক্ষণ করুন'))),
      ]),
    );
  }
}
