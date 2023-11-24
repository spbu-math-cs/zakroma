import 'package:http/http.dart' as http;

const serverAddress = '';

Future<http.Response> get(String token, String request) async {
  return http.get(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'});
}

Future<void> post<T>(String token, String request, T body) async {
  await http.post(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'}, body: body);
}

Future<void> patch<T>(String token, String request, T body) async {
  await http.patch(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'}, body: body);
}

Future<void> delete(String token, String request) async {
  await http.delete(Uri.parse('$serverAddress/$request'),
      headers: {'Authorization': 'Bearer $token'});
}
