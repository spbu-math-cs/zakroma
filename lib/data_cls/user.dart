import 'dart:async';
import 'dart:convert';

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
  final String? idCookie;
  final bool sync;

  const User(
      {this.firstName,
      this.secondName,
      this.thirdName,
      this.email,
      this.password,
      this.token,
      this.idCookie,
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
        'idCookie: $idCookie,\n'
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
    prefs.remove('idCookie');

    final tokenValid = await _isTokenValid(
        prefs.getString('email')!, prefs.getString('token'));
    if (prefs.getString('email') != null && !tokenValid) {
      // пользователь зарегистрирован, но не имеет действующего токена
      await _authorize(prefs.getString('email')!, prefs.getString('password')!);
    }

    debugPrint('  UserNotifier.build() finished');
    return User(
      firstName: prefs.getString('firstName'),
      secondName: prefs.getString('secondName'),
      thirdName: prefs.getString('thirdName'),
      email: prefs.getString('email'),
      password: prefs.getString('password'),
      token: prefs.getString('token'),
      idCookie: prefs.getString('idCookie'),
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

  Future<void> _authorize(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
        await post('auth/login', {'username': email, 'password': password});
    final cookies = response.headers['set-cookie']!
        .split(';')
        .map((e) => MapEntry(e.split('=')[0], e.split('=')[1]));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    prefs.setString('token', body['token']);
    prefs.setString(
        'idCookie',
        cookies
            .firstWhere((element) => element.key == 'zakroma_session')
            .value);
  }
}

final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);
