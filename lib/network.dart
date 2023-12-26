import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const serverAddress =
    'http://10.0.2.2:8080'; // TODO(server): по готовности сервера заменить на адрес сервера

Future<http.Response> get(String request, String token, String idCookie) async {
  debugPrint('get($request, $token)');
  return http.get(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, idCookie));
}

Future<http.Response> post<T>(String request, T body,
    [String? token, String? idCookie]) async {
  return http.post(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, idCookie), body: json.encode(body));
}

Future<http.Response> patch<T>(
    String request, T body, String token, String idCookie) async {
  return http.patch(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, idCookie), body: body);
}

Future<http.Response> delete(
    String request, String token, String idCookie) async {
  return http.delete(Uri.parse('$serverAddress/$request'),
      headers: _createHeader(token, idCookie));
}

Map<String, String> _createHeader(String? token, String? idCookie) {
  Map<String, String> result = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };
  if (token != null) {
    result['Authorization'] = 'Bearer $token';
  }
  if (idCookie != null) {
    result['Cookie'] = 'zakroma_session=$idCookie';
  }
  return result;
}
