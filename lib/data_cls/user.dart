import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakroma_frontend/main.dart';
import 'package:zakroma_frontend/network.dart';

import 'group.dart';

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
    // debugPrint('  UserNotifier.build()');
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);

    final tokenValid = await _isTokenValid(
        prefs.getString('email')!, prefs.getString('token'));
    if (!(prefs.getBool('isAuthorized') ?? false) || !tokenValid) {
      // пользователь зарегистрирован, но не имеет действующего токена
      try {
        await authorize(
            prefs.getString('email')!, prefs.getString('password')!);
      } catch (e) {
        // debugPrint(e.toString());
      }
    }

    // debugPrint('  UserNotifier.build() finished');

    await ref.watch(userProvider.notifier).switchCurrentGroup(
        '997fb7e3e1a7b2a5d70ff1f9ecb7d011466b3c26e9e40f4886769274999c628a'); // TODO(test): переключиться на личную группу
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
    // debugPrint('authorize()');
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    final response = await post(
        'auth/login',
        {'email': email, 'password': password},
        null,
        prefs.getString('cookie'));
    // debugPrint(
    //     'authorize\tresponse.statusCode = ${response.statusCode},\nauthorize\tresponse.headers = ${response.headers}');
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
    // debugPrint('authorize\tresponse.body = ${body.toString()}\n\n');
    // TODO(idea): надо ли хранить email и password локально?
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('token', body['token']);
    prefs.setString(
        'cookie',
        cookies
            .firstWhere((element) => element.key == 'zakroma_session')
            .value);
    prefs.setBool('isAuthorized', true);
    _updateStateWith(
      firstName: prefs.getString('firstName'),
      secondName: prefs.getString('secondName'),
      email: prefs.getString('email'),
      password: prefs.getString('password'),
      token: prefs.getString('token'),
      cookie: prefs.getString('cookie'),
      isAuthorized: prefs.getBool('isAuthorized') ?? true,
    );
    state = AsyncData(User(
      firstName: prefs.getString('firstName'),
      secondName: prefs.getString('secondName'),
      email: prefs.getString('email'),
      password: prefs.getString('password'),
      token: prefs.getString('token'),
      cookie: prefs.getString('cookie'),
      isAuthorized: prefs.getBool('isAuthorized') ?? true,
    ));
    // debugPrint('authorize\tuser = ${state.value}');
  }

  Future<void> register(String firstName, String secondName, String email,
      String password) async {
    debugPrint('register()');
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
    debugPrint('register\tresponse.statusCode: ${response.statusCode}');
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
    debugPrint('register\tresponse.body: ${body.toString()}');
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

  Future<void> switchCurrentGroup(String groupHash) async {
    // debugPrint('switchCurrentGroup($groupHash)');
    final response = await patch(
      'api/groups/change',
      {
        'group-hash': groupHash,
      },
      state.value!.token!,
      state.value!.cookie!,
    );
    // debugPrint(
    //     'switchCurrentGroup\tresponse.statusCode = ${response.statusCode},\nresponse.body = ${response.body}');
    switch (response.statusCode) {
      case 200:
        final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
        prefs.setString('cookie', _getCookie(response));
        _updateStateWith(cookie: _getCookie(response));
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

  Future<List<Group>> get groups async {
    final response = await get(
      'api/groups/list',
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
    // debugPrint('user.groups\tresponse.body = ${response.body}');
    final groups = jsonDecode(response.body) as List<dynamic>;
    // debugPrint('user.groups\tresponse.body: ${groups.toString()}');
    return List<Group>.from(
        groups.map((e) => Group.fromJson(e as Map<String, dynamic>)));
  }

  String _getCookie(Response response) {
    final cookies = response.headers['set-cookie']!
        .split(';')
        .map((e) => MapEntry(e.split('=')[0], e.split('=')[1]));
    return cookies
        .firstWhere((element) => element.key == 'zakroma_session')
        .value;
  }

  void _updateStateWith(
      {String? firstName,
      String? secondName,
      String? email,
      String? password,
      String? token,
      String? cookie,
      bool? isAuthorized}) {
    state = AsyncData(User(
      firstName: firstName ?? state.value?.firstName,
      secondName: secondName ?? state.value?.secondName,
      email: email ?? state.value?.email,
      password: password ?? state.value?.password,
      token: token ?? state.value?.token,
      cookie: cookie ?? state.value?.cookie,
      isAuthorized: isAuthorized ?? state.value?.isAuthorized ?? false,
    ));
  }
}

final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);
