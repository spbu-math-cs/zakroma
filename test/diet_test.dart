import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
void main() {
  group('Personal diet only', () {
    test('Personal diet empty', () async {
      // TODO(test): https://docs.flutter.dev/testing/overview#widget-tests
      // тестирование AsyncNotifier: https://codewithandrea.com/articles/flutter-riverpod-generator/
    });
  });
}
