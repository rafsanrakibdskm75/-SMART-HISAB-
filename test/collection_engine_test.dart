// The same scenarios as tool/verify.dart, as flutter tests (Stage 2+ CI).
// Run: flutter test
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hisab/core/money.dart';
import 'package:smart_hisab/core/dhaka_time.dart';
import 'package:smart_hisab/domain/collection_models.dart';
import 'package:smart_hisab/domain/collection_engine.dart';

void main() {
  final schedule = CollectionSchedule(id: 's', personId: 'rahim',
      expectedPoisha: takaToPoisha(200), type: ScheduleType.daily,
      startDate: dateOnly(2026, 11, 1), effectiveFrom: dateOnly(2026, 11, 1));

  test('Test C: missed day is never merged', () {
    final obs = generateObligations(schedule, from: dateOnly(2026, 11, 12), to: dateOnly(2026, 11, 13));
    applyPayment(obs, CollectionPayment(id: 'p1', personId: 'rahim',
        amountPoisha: takaToPoisha(200), date: dateOnly(2026, 11, 13)));
    final s = summarizePerson(obs, today: dateOnly(2026, 11, 13));
    expect(s.todayReceivedPoisha, 20000);
    expect(s.overduePoisha, 20000);
  });

  test('Test D: partial payments accumulate', () {
    final obs = generateObligations(schedule, from: dateOnly(2026, 11, 12), to: dateOnly(2026, 11, 12));
    applyPayment(obs, CollectionPayment(id: 'p1', personId: 'rahim', amountPoisha: takaToPoisha(100), date: dateOnly(2026, 11, 12)));
    applyPayment(obs, CollectionPayment(id: 'p2', personId: 'rahim', amountPoisha: takaToPoisha(50), date: dateOnly(2026, 11, 12)));
    expect(obs.first.paidPoisha, 15000);
    expect(obs.first.remainingPoisha, 5000);
  });
}
