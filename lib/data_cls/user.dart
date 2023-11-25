import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakroma_frontend/network.dart';

class User {
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? email;
  final String? password;
  final String? token;
  final bool sync;

  const User(
      {this.firstName,
      this.secondName,
      this.thirdName,
      this.email,
      this.password,
      this.token,
      this.sync = true})
      : assert(!sync || (sync && token != ''));

  @override
  String toString() {
    return 'User{\n'
        'firstName: $firstName,\n'
        'secondName: $secondName,\n'
        'thirdName: $thirdName,\n'
        'email: $email,\n'
        'password: $password,\n'
        'token: $token,\n'
        'sync: $sync}';
  }
}

class UserNotifier extends AsyncNotifier<User> {
  @override
  FutureOr<User> build() async {
    debugPrint('  UserNotifier.build()');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // TODO(tape): убрать по готовности регистрации
    prefs.setString('email', 'admin');
    prefs.setString('password', 'milka');
    prefs.setBool('sync', true);
    prefs.remove('token');

    final tokenValid = await _isTokenValid(
        prefs.getString('email')!, prefs.getString('token'));
    if (prefs.getString('email') != null && !tokenValid) {
      // пользователь зарегистрирован, но не имеет действующего токена
      final token = await _getToken(
          prefs.getString('email')!, prefs.getString('password')!);
      prefs.setString('token', token);
    }

    debugPrint('  UserNotifier.build() finished');
    return User(
      firstName: prefs.getString('firstName'),
      secondName: prefs.getString('secondName'),
      thirdName: prefs.getString('thirdName'),
      email: prefs.getString('email'),
      password: prefs.getString('password'),
      token: prefs.getString('token'),
      sync: prefs.getBool('sync') ?? true,
    );
  }

  Future<bool> _isTokenValid(String email, String? token) async {
    if (token == null) {
      return false;
    } else {
      return false;
      // TODO(server): по готовности добавить запрос на проверку токена
      final response = await post(
          'request', // TODO(server): по готовности взять запрос из api
          {'username': email, 'token': token});
      return bool.parse(response.body);
    }
  }

  Future<String> _getToken(String email, String password) async {
    final response =
        await post('auth/login', {'username': email, 'password': password});
    return response.body;
  }
}

final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);
