import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/app/app_widget.dart';

void main() {
  testWidgets('HarvestApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HarvestApp());
    await tester.pump();
  });
}
