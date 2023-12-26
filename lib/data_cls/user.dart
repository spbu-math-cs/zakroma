import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakroma_frontend/main.dart';
import 'package:zakroma_frontend/network.dart';

class User {
  final String? firstName;
  final String? secondName;
  final String? email;
  final String? password;
  final String? token;
  final String? cookie;
  final bool isAuthorized;

  const User(
      {this.firstName,
      this.secondName,
      this.email,
      this.password,
      this.token,
      this.cookie,
      this.isAuthorized = false})
      : assert(!isAuthorized ||
            (isAuthorized && (token ?? '') != '' && (cookie ?? '') != ''));

  @override
  String toString() {
    return 'User{\n'
        'firstName: $firstName,\n'
        'secondName: $secondName,\n'
        'email: $email,\n'
        'password: $password,\n'
        'token: $token,\n'
        'cookie: $cookie,\n'
        'isAuthorized: $isAuthorized}';
  }
}

class UserNotifier extends AsyncNotifier<User> {
  @override
  FutureOr<User> build() async {
    debugPrint('  UserNotifier.build()');
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);

    final tokenValid = await _isTokenValid(
        prefs.getString('email')!, prefs.getString('token'));
    if (!(prefs.getBool('isAuthorized') ?? false) && !tokenValid) {
      // пользователь зарегистрирован, но не имеет действующего токена
      await authorize(prefs.getString('email')!, prefs.getString('password')!);
    }

    debugPrint('  UserNotifier.build() finished');
    return User(
      firstName: prefs.getString('firstName'),
      secondName: prefs.getString('secondName'),
      email: prefs.getString('email'),
      password: prefs.getString('password'),
      token: prefs.getString('token'),
      cookie: prefs.getString('cookie'),
      isAuthorized: prefs.getBool('isAuthorized') ?? true,
    );
  }

  Future<bool> _isTokenValid(String email, String? token) async {
    if (token == null) {
      return false;
    } else {
      return false;
      // TODO(server): по готовности добавить запрос на проверку токена
      // final response = await post(
      //     'request', // TODO(server): по готовности взять запрос из api
      //     {'username': email, 'token': token});
      // return bool.parse(response.body);
    }
  }

  Future<void> authorize(String email, String password) async {
    debugPrint('  UserNotifier.authorize()');
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    final response =
        await post('auth/login', {'email': email, 'password': password});
    debugPrint('response.statusCode: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw Exception('Неверный логин или пароль');
      case 400:
        throw Exception('Неверный запрос');
      default:
        throw Exception('Неизвестная ошибка');
    }
    final cookies = response.headers['set-cookie']!
        .split(';')
        .map((e) => MapEntry(e.split('=')[0], e.split('=')[1]));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('response.body: ${body.toString()}');
    // TODO(think): надо ли хранить email и password локально?
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('token', body['token']);
    prefs.setString(
        'cookie',
        cookies
            .firstWhere((element) => element.key == 'zakroma_session')
            .value);
    prefs.setBool('isAuthorized', true);
  }

  Future<void> register(String firstName, String secondName, String email,
      String password) async {
    debugPrint('  UserNotifier.authorize()');
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    final response = await post('auth/register', {
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
      'password': password,
      'birth-date':
          '2023-12-12', // TODO(func): при регистрации спрашивать дату рождения
    });
    debugPrint('response.statusCode: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw Exception('Пользователь с таким email уже зарегистрирован');
      case 400:
        throw Exception('Неверный запрос');
      default:
        throw Exception('Неизвестная ошибка');
    }
    final cookies = response.headers['set-cookie']!
        .split(';')
        .map((e) => MapEntry(e.split('=')[0], e.split('=')[1]));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('response.body: ${body.toString()}');
    prefs.setString('firstName', firstName);
    prefs.setString('secondName', secondName);
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('token', body['token']);
    prefs.setString(
        'cookie',
        cookies
            .firstWhere((element) => element.key == 'zakroma_session')
            .value);
    prefs.setBool('isAuthorized', true);
  }

  Future<void> createGroup(String groupName) async {
    final response = await post(
      'api/groups/create',
      {
        'name': groupName,
      },
      state.value?.token,
      state.value?.cookie,
    );
    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw Exception('Неавторизованный запрос');
      case 400:
        throw Exception('Неверный запрос');
      case 500:
        throw Exception('Внутренняя ошибка');
      default:
        throw Exception('Неизвестная ошибка');
    }
  }

  Future<void> changeGroup(String groupHash) async {
    final response = await patch(
      'api/groups/change',
      {
        'group-hash': groupHash,
      },
      state.value!.token!,
      state.value!.cookie!,
    );
    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw Exception('Неавторизованный запрос');
      case 400:
        throw Exception('Неверный запрос');
      case 500:
        throw Exception('Внутренняя ошибка');
      default:
        throw Exception('Неизвестная ошибка');
    }
  }
}

final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);
