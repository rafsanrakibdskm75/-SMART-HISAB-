/// Business dates use Asia/Dhaka (Master Prompt §2).
/// Bangladesh has observed UTC+6 with no DST since 2009, so a business
/// "date" is computed deterministically from UTC+6 — no device-timezone
/// dependence, which is exactly what a ledger needs. Full instants still
/// store real UTC timestamps; only the *business date bucket* uses this.
library;

const dhakaOffset = Duration(hours: 6);

/// The Dhaka calendar date (as a UTC-midnight DateTime, date-only) for an instant.
DateTime dhakaDateOf(DateTime instantUtc) {
  final d = instantUtc.toUtc().add(dhakaOffset);
  return DateTime.utc(d.year, d.month, d.day);
}

DateTime dhakaToday() => dhakaDateOf(DateTime.now().toUtc());

/// Date-only values are always DateTime.utc(y, m, d) in this codebase.
DateTime dateOnly(int y, int m, int d) => DateTime.utc(y, m, d);
DateTime addDays(DateTime date, int days) => date.add(Duration(days: days));
int daysBetween(DateTime a, DateTime b) => b.difference(a).inDays;

String dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime parseDateKey(String key) {
  final p = key.split('-');
  if (p.length != 3) throw FormatException('Invalid date key: $key');
  final y = int.parse(p[0]), m = int.parse(p[1]), d = int.parse(p[2]);
  final out = DateTime.utc(y, m, d);
  // DateTime.utc silently rolls overflows (month 13, Feb 30) into the next
  // month — reject anything that does not round-trip exactly.
  if (out.year != y || out.month != m || out.day != d) {
    throw FormatException('Invalid date: $key');
  }
  return out;
}

const bnMonths = ['জানুয়ারি','ফেব্রুয়ারি','মার্চ','এপ্রিল','মে','জুন','জুলাই','আগস্ট','সেপ্টেম্বর','অক্টোবর','নভেম্বর','ডিসেম্বর'];

String formatDateBn(DateTime date) => '${date.day} ${bnMonths[date.month - 1]} ${date.year}';
