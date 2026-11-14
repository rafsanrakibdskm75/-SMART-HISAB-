/// Money is ALWAYS integer poisha (1 taka = 100 poisha).
/// Floating-point arithmetic is never used for financial values (Master Prompt §14).
library;

/// Parse a user-entered taka string exactly, without doubles.
/// Accepts "200", "200.5", "200.50", "1,200.75", Bangla digits too.
int takaStringToPoisha(String input) {
  var s = toEnglishDigits(input.trim()).replaceAll(',', '').replaceAll('৳', '').trim();
  if (s.isEmpty) throw const FormatException('Empty amount');
  var negative = false;
  if (s.startsWith('-')) { negative = true; s = s.substring(1); }
  if (!RegExp(r'\d').hasMatch(s)) throw FormatException('Invalid amount: $input');
  final parts = s.split('.');
  if (parts.length > 2) throw FormatException('Invalid amount: $input');
  final whole = int.parse(parts[0].isEmpty ? '0' : parts[0]);
  var frac = 0;
  if (parts.length == 2) {
    var f = parts[1];
    if (f.length > 2) throw FormatException('More than 2 decimal places: $input');
    f = f.padRight(2, '0');
    frac = int.parse(f);
  }
  final v = whole * 100 + frac;
  return negative ? -v : v;
}

int takaToPoisha(num taka) {
  // Only for whole-taka convenience in code/tests. UI input must use takaStringToPoisha.
  if (taka != taka.roundToDouble()) {
    throw ArgumentError('Use takaStringToPoisha for fractional taka: $taka');
  }
  return taka.toInt() * 100;
}

const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
const _enDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

String toBanglaDigits(String s) {
  var out = s;
  for (var i = 0; i < 10; i++) { out = out.replaceAll(_enDigits[i], _bnDigits[i]); }
  return out;
}

String toEnglishDigits(String s) {
  var out = s;
  for (var i = 0; i < 10; i++) { out = out.replaceAll(_bnDigits[i], _enDigits[i]); }
  return out;
}

/// Bangladeshi (lakh) grouping: 1,00,000 — groups of 2 after the first 3.
String _lakhGroup(int whole) {
  final s = whole.toString();
  if (s.length <= 3) return s;
  final tail = s.substring(s.length - 3);
  var head = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (head.length > 2) {
    parts.insert(0, head.substring(head.length - 2));
    head = head.substring(0, head.length - 2);
  }
  if (head.isNotEmpty) parts.insert(0, head);
  return '${parts.join(',')},$tail';
}

/// Format poisha as ৳1,00,000 or ৳200.50 (decimals only when poisha remain).
String formatBdt(int poisha, {bool banglaDigits = false, bool showSymbol = true}) {
  final neg = poisha < 0;
  final abs = poisha.abs();
  final whole = abs ~/ 100;
  final frac = abs % 100;
  var body = _lakhGroup(whole);
  if (frac != 0) body = '$body.${frac.toString().padLeft(2, '0')}';
  var out = '${neg ? '-' : ''}${showSymbol ? '৳' : ''}$body';
  if (banglaDigits) out = toBanglaDigits(out);
  return out;
}
