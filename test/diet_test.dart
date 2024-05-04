import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:zakroma_frontend/data_cls/day_diet.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/data_cls/user.dart';

import 'diet_test.mocks.dart';

class MockUser extends Mock implements UserNotifier {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

@GenerateMocks([http.Client])
void main() {
  ProviderContainer makeProviderContainer(MockUser userNotifier) {
    final container = ProviderContainer(
      overrides: [
        userProvider.overrideWith(() => userNotifier),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Personal diet only', () {
    test('Personal diet empty', () async {
      final dietNotifier = DietNotifier();
      // https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
      final container = makeProviderContainer(MockUser());
      final listener = Listener<AsyncValue<User>>();
      container.listen(
        userProvider,
        listener,
        fireImmediately: true,
      );
      final dietData = {
        'id': 0,
        'hash': 'diet-0',
        'name': 'Личный рацион test',
        'day-diets': List<DayDiet?>.generate(7, (index) => null)
      };
      dietNotifier.client = MockClient();
      when(dietNotifier.client
              .get(Uri.parse('http://localhost:8080/api/diets/personal')))
          .thenAnswer((_) async => http.Response(dietData.toString(), 200));
      // TODO: здесь в build используется userProvider, и нужно его как-то
      // переопределить с помощью override — решение выше не работает
      dietNotifier.build();
      assert(dietNotifier.state.hasValue);

      final diet = dietNotifier.state.value!;
      assert(diet.second == null);

      final personalDiet = diet.first;
      expect(personalDiet.isPersonal, true);
      expect(personalDiet.name, dietData['name']);
      expect(personalDiet.hash, dietData['hash']);
      expect(personalDiet.days, []);
    });
  });
}
