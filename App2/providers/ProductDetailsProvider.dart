import 'package:flutter/material.dart';
import '../data/CartService.dart';


class ProductDetailsProvider extends ChangeNotifier {
  final CartService cartService = CartService();

  bool isLoading = false;
  String? error;

  // دالة إضافة المنتج للسلة مع إدارة حالة التحميل والأخطاء
  Future<bool> addToCart(int userId, int productId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await cartService.addToCart(userId, productId);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}