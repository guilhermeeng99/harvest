import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/app/app_widget.dart';

void main() {
  test('HarvestApp smoke test', () {
    // Verifies that HarvestApp can be instantiated.
    // Full widget tests require DI setup (GetIt) and are covered
    // by feature-level tests.
    const app = HarvestApp();
    expect(app, isA<HarvestApp>());
  });
}
