import 'package:flutter_test/flutter_test.dart';
import 'package:scam_shield/main.dart';

void main() {
  testWidgets('Auth wrapper smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ScamShieldApp());
    expect(find.byType(ScamShieldApp), findsOneWidget);
  });
}
