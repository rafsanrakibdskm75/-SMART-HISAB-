import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/person.dart';
import 'person_controller.dart';

/// Add-person form — short, Bangla, numeric keyboard for mobile (§17).
class PersonFormScreen extends StatefulWidget {
  const PersonFormScreen({super.key});
  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();
  PersonType _type = PersonType.customer;
  String? _error;

  @override
  void dispose() {
    _name.dispose(); _mobile.dispose(); _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final c = Get.find<PersonController>();
    final err = await c.addPerson(
      name: _name.text,
      mobile: _mobile.text.isEmpty ? null : _mobile.text,
      address: _address.text.isEmpty ? null : _address.text,
      type: _type);
    if (err != null) {
      setState(() => _error = err);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন ব্যক্তি')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'নাম *')),
        const SizedBox(height: 12),
        TextField(controller: _mobile, keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'মোবাইল (01XXXXXXXXX)')),
        const SizedBox(height: 12),
        TextField(controller: _address, decoration: const InputDecoration(labelText: 'ঠিকানা')),
        const SizedBox(height: 12),
        DropdownButtonFormField<PersonType>(
          initialValue: _type,
          decoration: const InputDecoration(labelText: 'ধরন'),
          items: const [
            DropdownMenuItem(value: PersonType.customer, child: Text('কাস্টমার')),
            DropdownMenuItem(value: PersonType.family, child: Text('পরিবার / আত্মীয়')),
            DropdownMenuItem(value: PersonType.somityMember, child: Text('সমিতি সদস্য')),
            DropdownMenuItem(value: PersonType.renter, child: Text('ভাড়াটিয়া (টোকরি)')),
            DropdownMenuItem(value: PersonType.other, child: Text('অন্যান্য')),
          ],
          onChanged: (v) => setState(() => _type = v ?? PersonType.customer),
        ),
        if (_error != null)
          Padding(padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 20),
        SizedBox(height: 52, child: FilledButton(
          onPressed: _save, child: const Text('সংরক্ষণ করুন'))),
      ]),
    );
  }
}
