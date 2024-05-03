import 'dart:convert';

import 'package:http/http.dart' as http;

// TODO(server): по готовности сервера заменить на адрес сервера
const serverAddress = 'http://10.0.2.2:8080';

http.Client client = http.Client();

Uri makeUri(String request) => Uri.parse('$serverAddress/$request');

Map<String, String> makeHeader(String? token, String? cookie) {
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
