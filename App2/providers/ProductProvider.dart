import 'package:flutter/material.dart';

import '../data/ProductService.dart';


class ProductProvider extends ChangeNotifier {
  final ProductService productService = ProductService();

  List<dynamic> products = [];
  bool isLoading = false;
  String? error;

  // جلب المنتجات باستخدام ProductService
  Future<void> fetchProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      products = await productService.getProducts();
    } catch (e) {
      error = 'Failed to load products: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}