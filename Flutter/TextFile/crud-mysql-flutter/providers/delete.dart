import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> deleteUser(int id) async {
  final res = await http.post(
    Uri.parse('http://127.0.0.1/backendflutter/delete.php'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id}),
  );
  if (res.statusCode != 200) throw Exception('Gagal hapus data');
}
