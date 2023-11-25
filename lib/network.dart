import 'dart:convert';

import 'package:http/http.dart' as http;

const serverAddress = 'http://10.0.2.2:8080'; // TODO(server): по готовности сервера заменить на адрес сервера

Future<http.Response> get(String request, String token) async {
  return http.get(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'});
}

Future<http.Response> post<T>(String request, T body, [String? token]) async {
  final headers = {'content-type' : 'application/json',
    'accept' : 'application/json'};
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  return http.post(Uri.parse('$serverAddress/$request'),
      headers: headers,
      body: json.encode(body));
}

Future<http.Response> patch<T>(String request, T body, String token) async {
  return http.patch(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'}, body: body);
}

Future<http.Response> delete(String request, String token) async {
  return http.delete(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'});
}
