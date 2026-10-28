import 'package:flutter/material.dart';
import '../data/CategoryService.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService categoryService = CategoryService();

  List<dynamic> categories = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCategories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      categories = await categoryService.getCategories();
    } catch (e) {
      error = 'Failed to load categories: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}