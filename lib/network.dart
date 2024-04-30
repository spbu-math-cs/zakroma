import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// TODO(server): по готовности сервера заменить на адрес сервера
const serverAddress = 'http://10.0.2.2:8080';

Future<http.Response> get(String request, String token, String cookie) async {
  // debugPrint('---GET---\n($request, $token, $cookie)');
  return http.get(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, cookie));
}

Future<http.Response> post<T>(String request, T body,
    [String? token, String? cookie]) async {
  // debugPrint(
  //     '---POST---\n(request = $request, body = $body, token = $token, cookie = $cookie])');
  return http.post(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, cookie), body: json.encode(body));
}

Future<http.Response> patch<T>(
    String request, T body, String token, String cookie) async {
  // debugPrint(
  //     '---PATCH---\n(request = $request, body = $body, token = $token, cookie = $cookie])');
  return http.patch(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, cookie), body: json.encode(body));
}

Future<http.Response> delete(
    String request, String token, String cookie) async {
  return http.delete(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, cookie));
}

Map<String, String> _createHeader(String? token, String? cookie) {
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

Map<String, dynamic> processResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body) as Map<String, dynamic>;
    case 401:
      throw Exception('Пользователь не авторизован');
    case 400:
      throw Exception('Некорректный запрос');
    case 500:
      throw Exception('Внутренняя ошибка на сервере');
    default:
      throw Exception('Неизвестная ошибка');
  }
}
