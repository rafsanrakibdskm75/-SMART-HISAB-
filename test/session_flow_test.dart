/// Session gate tests (v1.1.3): create account (local, Firebase not
/// configured), password sign-in, offline mode, biometric unlock rules.
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hisab/data/auth/biometric_service.dart';
import 'package:smart_hisab/data/repositories/in_memory_repositories.dart';
import 'package:smart_hisab/data/sync/auth_service.dart';
import 'package:smart_hisab/features/auth/session_controller.dart';

class FakeBiometrics implements BiometricService {
  bool available;
  bool result;
  FakeBiometrics({this.available = true, this.result = true});
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<bool> authenticate() async => result;
}

void main() {
  late InMemoryStore store;
  late SessionController c;
  late FakeBiometrics bio;

  setUp(() async {
    store = InMemoryStore();
    bio = FakeBiometrics();
    c = SessionController(InMemorySettingsRepository(store), AuthService(), bio);
    await c.load();
  });

  Future<String?> create() => c.createAccount(
        businessName: 'রহিম স্টোর',
        ownerName: 'Rahim',
        mobile: '01712345678',
        email: 'Rahim@Example.com',
        password: 'secret1',
        confirmPassword: 'secret1',
      );

  test('first run: gate shows login', () {
    expect(c.hasAccount, isFalse);
    expect(c.decide(), GateDecision.login);
  });

  test('create account stores profile + salted hash, never the password', () async {
    expect(await create(), isNull);
    final s = store.settings;
    expect(s.businessName, 'রহিম স্টোর');
    expect(s.accountEmail, 'rahim@example.com'); // normalised
    expect(s.localPasswordHash, isNotEmpty);
    expect(s.localPasswordHash.contains('secret1'), isFalse);
    expect(c.decide(), GateDecision.home); // signed in right away
  });

  test('create validation: mismatched confirm + short password + bad mobile', () async {
    expect(
        await c.createAccount(
            businessName: 'X', ownerName: 'Y', mobile: '',
            email: 'a@b.co', password: 'secret1', confirmPassword: 'secret2'),
        isNotNull);
    expect(
        await c.createAccount(
            businessName: 'X', ownerName: 'Y', mobile: '',
            email: 'a@b.co', password: '123', confirmPassword: '123'),
        isNotNull);
    expect(
        await c.createAccount(
            businessName: 'X', ownerName: 'Y', mobile: '12345',
            email: 'a@b.co', password: 'secret1', confirmPassword: 'secret1'),
        isNotNull);
    expect(c.hasAccount, isFalse);
  });

  test('sign-in: wrong password and wrong email rejected, right one works', () async {
    await create();
    final c2 = SessionController(InMemorySettingsRepository(store), AuthService(), bio);
    await c2.load();
    expect(await c2.signIn('rahim@example.com', 'wrong-pass'), isNotNull);
    expect(c2.signedIn.value, isFalse);
    expect(await c2.signIn('other@example.com', 'secret1'), isNotNull);
    expect(await c2.signIn('rahim@example.com', 'secret1'), isNull);
    expect(c2.decide(), GateDecision.home);
  });

  test('sign-in with no account tells the user to create one', () async {
    final err = await c.signIn('a@b.co', 'secret1');
    expect(err, isNotNull);
    expect(err, contains('অ্যাকাউন্ট তৈরি'));
  });

  test('offline continue is remembered across restarts', () async {
    await c.continueOffline();
    expect(c.decide(), GateDecision.home);
    final c2 = SessionController(InMemorySettingsRepository(store), AuthService(), bio);
    await c2.load();
    expect(c2.decide(), GateDecision.home); // no gate next start
  });

  auditGroup();

  test('biometric unlock: only when enabled + account + prompt succeeds', () async {
    await create();
    final c2 = SessionController(
        InMemorySettingsRepository(store), AuthService(), FakeBiometrics(result: true));
    await c2.load();
    expect(c2.biometricOffered, isFalse); // not enabled yet
    expect(await c2.unlockWithBiometric(), isFalse);
    await c2.setBiometricEnabled(true);
    expect(c2.biometricOffered, isTrue);
    expect(await c2.unlockWithBiometric(), isTrue);
    expect(c2.signedIn.value, isTrue);

    final c3 = SessionController(InMemorySettingsRepository(store), AuthService(),
        FakeBiometrics(result: false)); // user cancels the prompt
    await c3.load();
    expect(await c3.unlockWithBiometric(), isFalse);
    expect(c3.signedIn.value, isFalse);
  });
}

/// v1.1.5 audit additions — appended group.
void auditGroup() {
  group('v1.1.5 audit', () {
    late InMemoryStore store;
    late SessionController c;

    setUp(() async {
      store = InMemoryStore();
      c = SessionController(
          InMemorySettingsRepository(store), AuthService(), FakeBiometrics());
      await c.load();
    });

    test('offline continue must NOT bypass the gate when an account exists', () async {
      await c.createAccount(
          businessName: 'দোকান', ownerName: 'Rahim', mobile: '',
          email: 'a@b.co', password: 'secret1', confirmPassword: 'secret1');
      // Fresh start (nobody signed in yet):
      final c2 = SessionController(
          InMemorySettingsRepository(store), AuthService(), FakeBiometrics());
      await c2.load();
      await c2.continueOffline();
      expect(store.settings.offlineMode, isFalse,
          reason: 'offlineMode must not be set for an account holder');
      expect(c2.decide(), GateDecision.login,
          reason: 'gate must still ask for the password next start');
    });

    test('biometric toggle must not clobber settings changed after splash', () async {
      await c.createAccount(
          businessName: 'পুরনো দোকান', ownerName: 'Rahim', mobile: '',
          email: 'a@b.co', password: 'secret1', confirmPassword: 'secret1');
      // Meanwhile the owner edits profile in Settings (another controller
      // writes a FRESH AppSettings into the same store):
      final repo = InMemorySettingsRepository(store);
      final fresh = (await repo.load()).copyWith(
          businessName: 'নতুন দোকান', dailyClosingReminder: false);
      await repo.save(fresh);
      // Now the session toggles fingerprint from its splash-time copy:
      await c.setBiometricEnabled(true);
      expect(store.settings.businessName, 'নতুন দোকান',
          reason: 'newer profile edit must survive the toggle');
      expect(store.settings.dailyClosingReminder, isFalse,
          reason: 'newer reminder setting must survive the toggle');
      expect(store.settings.biometricEnabled, isTrue);
    });
  });
}
