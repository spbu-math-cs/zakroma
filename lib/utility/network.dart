import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'constants.dart';

part 'network.g.dart';

Uri makeUri(String request) => Uri.parse('${Constants.serverAddress}/$request');

Map<String, String> makeHeader([String? token, String? cookie]) {
  Map<String, String> result = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };
  if (token != null) {
    result['Authorization'] = 'Bearer $token';
  }
  if (cookie != null) {
    result['Cookie'] = 'zakroma_session=$cookie';
  }
  return result;
}

List<Map<String, dynamic>> processResponse(http.Response response) {
  debugPrint('DEBUG: statusCode = ${response.statusCode.toString()}');
  debugPrint('DEBUG: body = ${response.body}');
  switch (response.statusCode) {
    case 200:
      final body = response.body;
      if (body.isEmpty || body == 'null') {
        return [];
      } else {
        try {
          final entries = jsonDecode(response.body) as List<dynamic>;
          return entries.map((e) => e as Map<String, dynamic>).toList();
        } catch (e) {
          return [jsonDecode(response.body) as Map<String, dynamic>];
        }
      }
    case 401:
      throw Exception('Пользователь не авторизован');
    case 400:
      throw Exception('Некорректный запрос');
    case 404:
      throw Exception('Страница не найдена');
    case 408:
      throw Exception('Истекло время ожидания');
    case 500:
      throw Exception('Внутренняя ошибка сервера');
    default:
      throw Exception('Неизвестная ошибка');
  }
}

@Riverpod(keepAlive: true)
class Client extends _$Client {
  @override
  http.Client build() {
    return http.Client();
  }

  Future<http.Response> get<T>(String request,
      {T? body, String? token, String? cookie}) async {
    // debugPrint('---GET---\n($request, $token, $cookie)');
    final httpRequest = http.Request('GET', makeUri(request));
    httpRequest.body = jsonEncode(body);
    return http.Response.fromStream(await state.send(httpRequest));
    return state
        .get(makeUri(request), headers: makeHeader(token, cookie))
        .timeout(Constants.networkTimeout,
            onTimeout: () => http.Response('', 408));
  }

  Future<http.Response> post<T>(String request,
      {required T body, String? token, String? cookie}) async {
    // debugPrint(
    //     '---POST---\n(request = $request, body = $body, token = $token, cookie = $cookie])');
    return state
        .post(makeUri(request),
            headers: makeHeader(token, cookie), body: json.encode(body))
        .timeout(Constants.networkTimeout,
            onTimeout: () => http.Response('', 408));
  }

  Future<http.Response> patch<T>(String request,
      {required T body, required String token, required String cookie}) async {
    // debugPrint(
    //     '---PATCH---\n(request = $request, body = $body, token = $token, cookie = $cookie])');
    return state
        .patch(makeUri(request),
            headers: makeHeader(token, cookie), body: json.encode(body))
        .timeout(Constants.networkTimeout,
            onTimeout: () => http.Response('', 408));
  }

  Future<http.Response> delete(String request,
      {required String token, required String cookie}) async {
    return state
        .delete(makeUri(request), headers: makeHeader(token, cookie))
        .timeout(Constants.networkTimeout,
            onTimeout: () => http.Response('', 408));
  }
}
