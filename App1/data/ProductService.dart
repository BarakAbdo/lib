import 'dart:convert';
import 'package:http/http.dart' as http;

import 'conncetion.dart';

class ProductService {
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse(ConnectionString.products),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}