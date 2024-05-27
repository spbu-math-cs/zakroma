import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' show Response;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/network.dart';
import '../utility/shared_preferences.dart';
import 'group.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(toJson: false, fromJson: false)
class UserData with _$UserData {
  const UserData._();

  const factory UserData(
      {required String firstName,
      required String secondName,
      required String userPicUrl,
      required String email,
      required String password,
      required String token,
      required String cookie}) = _UserData;

  const factory UserData.error(
      [@Default('error') String firstName,
      @Default('error') String secondName,
      @Default('error') String userPicUrl,
      @Default('error') String email,
      @Default('error') String password,
      @Default('') String token,
      @Default('') String cookie]) = UserDataError;

  const factory UserData.empty(
      [@Default('null') String firstName,
      @Default('null') String secondName,
      @Default('null') String userPicUrl,
      @Default('null') String email,
      @Default('null') String password,
      @Default('') String token,
      @Default('') String cookie]) = UserDataEmpty;

  @override
  String toString() {
    return 'UserData{\n'
        'firstName: $firstName,\n'
        'secondName: $secondName,\n'
        'userPicUrl ${userPicUrl.substring(0, 10)},\n'
        'email: $email,\n'
        'password: $password,\n'
        'token: $token,\n'
        'cookie: $cookie,\n';
  }
}

@Riverpod(keepAlive: true)
class User extends _$User {
  @override
  FutureOr<UserData> build() async {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);

    if (isUserAuthorized()) {
      return UserData(
          // TODO(server): сделать запросы firstName, secondName и userPicUrl к серверу
          firstName: 'firstName',
          secondName: 'secondName',
          userPicUrl:
              'https://w7.pngwing.com/pngs/356/733/png-transparent-emoticon-smiley-yellow-ball-happy-emoji-emotion-funny-emoticons-cartoon.png',
          email: 'email',
          password: 'password',
          token: prefs.getString('token')!,
          cookie: prefs.getString('cookie')!);
    }
    return const UserData.error();
  }

  UserData getUser() {
    if (state.asData == null) {
      throw Exception('Пользователь не авторизован');
    }
    return state.asData!.value;
  }

  bool isUserAuthorized() {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString('token') != null &&
        prefs.getString('cookie') != null;
  }

  Future<void> authorize(String email, String password) async {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    final response = await ref
        .watch(clientProvider.notifier)
        .post('auth/login', body: {'email': email, 'password': password});
    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw Exception('Неверный логин или пароль');
      case 400:
        throw Exception('Неверный запрос');
      default:
        debugPrint('${response.statusCode}');
        throw Exception('Неизвестная ошибка');
    }
    final cookies = response.headers['set-cookie']!
        .split(';')
        .map((e) => MapEntry(e.split('=')[0], e.split('=')[1]));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final nameBody = processResponse(await ref.watch(clientProvider).get(
            makeUri('api/user/name'),
            headers: makeHeader(
                body['token'],
                cookies
                    .firstWhere((element) => element.key == 'zakroma_session')
                    .value)))
        .first;
    _updateSharedPrefs(
      token: body['token'],
      cookie: cookies
          .firstWhere((element) => element.key == 'zakroma_session')
          .value,
    );
    _updateStateWith(
      // TODO(server): сделать запросы userPicUrl к серверу
      firstName: nameBody['name'],
      secondName: nameBody['surname'],
      userPicUrl:
          'https://w7.pngwing.com/pngs/356/733/png-transparent-emoticon-smiley-yellow-ball-happy-emoji-emotion-funny-emoticons-cartoon.png',
      email: email,
      password: password,
      token: prefs.getString('token'),
      cookie: prefs.getString('cookie'),
    );
    if (email == 'gosling@yandex.ru') {
      // TODO(tape): убрать
      debugPrint('DEBUG: it\'s Ryan Gosling in the flesh!!!');
      switchCurrentGroup(
          '997fb7e3e1a7b2a5d70ff1f9ecb7d011466b3c26e9e40f4886769274999c628a');
    }
  }

  Future<void> register(String firstName, String secondName, String email,
      String password) async {
    final response =
        await ref.watch(clientProvider.notifier).post('auth/register', body: {
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
      'password': password,
      // TODO(design): при регистрации спрашивать дату рождения
      'birth-date': '2023-12-12',
    });
    switch (response.statusCode) {
      case 200:
        break;
      case 401:
        throw Exception('Пользователь с таким email уже зарегистрирован');
      case 400:
        throw Exception('Неверный запрос');
      default:
        debugPrint('${response.statusCode}');
        throw Exception('Неизвестная ошибка');
    }
    await authorize(email, password);
  }

  void logout() {
    _updateSharedPrefs(token: null, cookie: null);
    state = const AsyncData(UserData.empty());
  }

  Future<void> createGroup(String groupName) async {
    final response = await ref.watch(clientProvider.notifier).post(
          'api/groups/create',
          body: {'name': groupName},
          token: state.value?.token,
          cookie: state.value?.cookie,
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
    final response = await ref.watch(clientProvider.notifier).patch(
        'api/groups/change',
        body: {'group-hash': groupHash},
        token: state.value!.token,
        cookie: state.value!.cookie);
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
    final response = await ref.watch(clientProvider.notifier).get(
        'api/groups/list',
        token: state.value!.token,
        cookie: state.value!.cookie);
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

  void updatePic(String picPath) {_updateStateWith(userPicUrl: picPath);}

  void _updateStateWith(
      {String? firstName,
      String? secondName,
      String? userPicUrl,
      String? email,
      String? password,
      String? token,
      String? cookie}) {
    state = AsyncData(UserData(
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
