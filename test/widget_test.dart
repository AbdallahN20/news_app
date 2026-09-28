import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';

void main() {
  testWidgets('NewsApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
