import 'dart:convert';
import 'package:crud_mysql_flutter/class/class.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1/backendflutter/read.php'),
  );

  if (response.statusCode == 200) {
    List jsonData = jsonDecode(response.body);
    return jsonData.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception('Gagal memuat data');
  }
}
