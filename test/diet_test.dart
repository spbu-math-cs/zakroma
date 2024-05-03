import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
// import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:zakroma_frontend/data_cls/diet.dart';
import 'diet_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Personal diet', () {
    test('', () async {
      final dietNotifier = DietNotifier();
      dietNotifier.client = MockClient();
      when(dietNotifier.client
              .get(Uri.parse(''))) // TODO: добавить запрос на личную диету
          .thenAnswer((_) async => http.Response('',
              200)); // TODO: добавить ответ (диета: имя, список хэшей day-diet)
    });
  });
}
