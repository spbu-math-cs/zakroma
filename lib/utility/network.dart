import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

part 'network.g.dart';

// TODO(server): по готовности сервера заменить на адрес сервера
const serverAddress = 'http://10.2.0:8080';

Uri makeUri(String request) => Uri.parse('$serverAddress/$request');

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
  // debugPrint('DEBUG: statusCode = ${response.statusCode.toString()}');
  // debugPrint('DEBUG: body = ${response.body}');
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
    case 500:
      throw Exception('Внутренняя ошибка на сервере');
    default:
      throw Exception('Неизвестная ошибка');
  }
}

@Riverpod(keepAlive: true)
http.Client client(ClientRef ref) {
  return http.Client();
}
