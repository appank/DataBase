import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createUser(String name, String email) async {
  final res = await http.post(
    Uri.parse('http://127.0.0.1/backendflutter/create.php'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name, 'email': email}),
  );
  if (res.statusCode != 200) throw Exception('Gagal menambah user');
}
