import 'package:fitguard/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the FitGuard landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const FitGuardApp());
    expect(find.text('FitGuard'), findsOneWidget);
    expect(find.text('Design System'), findsOneWidget);
  });
}
