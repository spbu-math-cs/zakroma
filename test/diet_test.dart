import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:zakroma_frontend/data_cls/day_diet.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/data_cls/user.dart';

import 'diet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Personal diet only', () {
    test('Personal diet empty', () async {
      // TODO(test): https://docs.flutter.dev/testing/overview#widget-tests
      // тестирование AsyncNotifier: https://codewithandrea.com/articles/flutter-riverpod-generator/
    });
  });
}
