import 'dart:convert';
import 'package:http/http.dart' as http;

import 'conncetion.dart';

class CategoryService {
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse(ConnectionString.category),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }
}