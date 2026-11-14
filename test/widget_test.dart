import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_hisab/app/bindings.dart';
import 'package:smart_hisab/features/home/home_shell.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(() {
    Get.reset();
    Get.testMode = false;
  });

  testWidgets('home shell shows the current navigation destinations',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialBinding: AppBindings(),
      home: const HomeShell(),
    ));
    await tester.pump();

    expect(find.text('দৈনিক হিসাব'), findsWidgets);
    expect(find.text('ব্যক্তি'), findsWidgets);
    expect(find.text('আদায়'), findsWidgets);
    expect(find.text('সেবা'), findsWidgets);
    expect(find.text('ইতিহাস'), findsWidgets);
  });
}
