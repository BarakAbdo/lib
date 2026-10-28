import 'package:flutter/material.dart';
import '../data/CartService.dart';

class CartProvider extends ChangeNotifier {
  final CartService cartService = CartService();

  List<dynamic> cartItems = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCart(int userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      cartItems = await cartService.getCart(userId);
    } catch (e) {
      error = 'Failed to load cart: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int userId, int productId, BuildContext context) async {
    try {
      await cartService.addToCart(userId, productId);
      await fetchCart(userId);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> removeFromCart(int userId, int productId) async {
    try {
      await cartService.removeFromCart(userId, productId);
      cartItems.removeWhere((item) => item['productId'] == productId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to remove product: $e');
    }
  }
}