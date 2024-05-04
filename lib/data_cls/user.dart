import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response, Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakroma_frontend/main.dart';
import 'package:zakroma_frontend/network.dart';

import 'group.dart';

class User {
  final String firstName;
  final String secondName;
  final String userPicUrl;
  final String email;
  final String password;
  final String token;
  final String cookie;

  const User(
      {required this.firstName,
      required this.secondName,
      required this.userPicUrl,
      required this.email,
      required this.password,
      required this.token,
      required this.cookie});

  const User.error(
      {this.firstName = 'error',
      this.secondName = 'error',
      this.userPicUrl =
          'https://cdn4.iconfinder.com/data/icons/smiley-vol-3-2/48/134-1024.png',
      this.email = 'error',
      this.password = 'error',
      this.token = '',
      this.cookie = ''});

  @override
  String toString() {
    return 'User{\n'
        'firstName: $firstName,\n'
        'secondName: $secondName,\n'
        'userPicUrl ${userPicUrl.substring(0, 10)},\n'
        'email: $email,\n'
        'password: $password,\n'
        'token: $token,\n'
        'cookie: $cookie,\n';
  }
}

class UserNotifier extends AsyncNotifier<User> {
  Client client = Client();

  @override
  FutureOr<User> build() async {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);

    if (isUserAuthorized()) {
      return User(
          // TODO(server): сделать запросы firstName, secondName и userPicUrl к серверу
          firstName: 'firstName',
          secondName: 'secondName',
          userPicUrl:
              'https://w7.pngwing.com/pngs/356/733/png-transparent-emoticon-smiley-yellow-ball-happy-emoji-emotion-funny-emoticons-cartoon.png',
          email: 'email',
          password: 'password',
          token: prefs.getString('token')!,
          cookie: prefs.getString('cookie')!);
    } else {
      try {
        await authorize(
            prefs.getString('email')!, prefs.getString('password')!);
        return state.value!;
      } catch (e, stackTrace) {
        if (e.toString() != 'Null check operator used on a null value') {
          debugPrint(e.toString());
          debugPrintStack(stackTrace: stackTrace);
        }
      }
      return const User.error();
    }
  }

  bool isUserAuthorized() {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString('token') != null &&
        prefs.getString('cookie') != null;
  }

  Future<void> authorize(String email, String password) async {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    final response = await client.post(makeUri('auth/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: makeHeader(null, prefs.getString('cookie')));
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
    _updateSharedPrefs(
      token: body['token'],
      cookie: cookies
          .firstWhere((element) => element.key == 'zakroma_session')
          .value,
    );
    _updateStateWith(
      // TODO(server): сделать запросы firstName, secondName и userPicUrl к серверу
      firstName: 'firstName',
      secondName: 'secondName',
      userPicUrl:
          'https://w7.pngwing.com/pngs/356/733/png-transparent-emoticon-smiley-yellow-ball-happy-emoji-emotion-funny-emoticons-cartoon.png',
      email: email,
      password: password,
      token: prefs.getString('token'),
      cookie: prefs.getString('cookie'),
    );
    if (prefs.getString('email') == 'gosling@yandex.ru') {
      // TODO(tape): убрать
      switchCurrentGroup(
          '997fb7e3e1a7b2a5d70ff1f9ecb7d011466b3c26e9e40f4886769274999c628a');
    }
  }

  Future<void> register(String firstName, String secondName, String email,
      String password) async {
    final response = await client.post(makeUri('auth/register'),
        body: jsonEncode({
          'firstName': firstName,
          'secondName': secondName,
          'email': email,
          'password': password,
          // TODO(design): при регистрации спрашивать дату рождения
          'birth-date': '2023-12-12',
        }),
        headers: makeHeader());
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
    await authorize(email, password);
  }

  void logout() {
    _updateSharedPrefs(token: null, cookie: null);
    state = const AsyncData(User.error());
  }

  Future<void> createGroup(String groupName) async {
    final response = await client.post(makeUri('api/groups/create'),
        body: jsonEncode({'name': groupName}),
        headers: makeHeader(
          state.value?.token,
          state.value?.cookie,
        ));
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
    final response = await client.patch(makeUri('api/groups/change'),
        body: jsonEncode({'group-hash': groupHash}),
        headers: makeHeader(state.value!.token, state.value!.cookie));
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
    final response = await client.get(makeUri('api/groups/list'),
        headers: makeHeader(state.value!.token, state.value!.cookie));
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
      String? userPicUrl,
      String? email,
      String? password,
      String? token,
      String? cookie}) {
    state = AsyncData(User(
      firstName: firstName ?? state.value!.firstName,
      secondName: secondName ?? state.value!.secondName,
      userPicUrl: userPicUrl ?? state.value!.userPicUrl,
      email: email ?? state.value!.email,
      password: password ?? state.value!.password,
      token: token ?? state.value!.token,
      cookie: cookie ?? state.value!.cookie,
    ));
  }

  void _updateSharedPrefs({String? token, String? cookie}) async {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (token != null) {
      prefs.setString('token', token);
    } else {
      prefs.remove('token');
    }
    if (cookie != null) {
      prefs.setString('cookie', cookie);
    } else {
      prefs.remove('cookie');
    }
  }
}

final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);
