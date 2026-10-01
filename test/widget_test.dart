import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_webspark/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Чистий аркуш!'), findsOneWidget);
  });
}
