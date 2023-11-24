import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO(tech): дописать класс пользователя
class User {
  final String firstName;
  final String secondName;
  final String thirdName;
  final String token;
  final bool sync;

  const User(
      {required this.firstName,
      required this.secondName,
      required this.thirdName,
      required this.token,
      this.sync = true}) : assert(!sync || (sync && token != ''));
}

class UserNotifier extends AsyncNotifier<User> {
  @override
  FutureOr<User> build() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return User(
        firstName: prefs.getString('firstName') ?? '',
        secondName: prefs.getString('secondName') ?? '',
        thirdName: prefs.getString('thirdName') ?? '',
        token: prefs.getString('token') ?? '',
        sync: prefs.getBool('sync') ?? true,
    );
  }
}

final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);
