import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_webspark/main.dart';

void main() {
  testWidgets('App renders HomeScreen correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home screen'), findsOneWidget);
    expect(
      find.text('Set valid API base URL in order to continue'),
      findsOneWidget,
    );
    expect(find.text('Start counting process'), findsOneWidget);
  });
}
