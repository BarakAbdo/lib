import 'package:flutter/material.dart';
import '../data/OrderService.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService orderService = OrderService();

  List<dynamic> orders = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchMyOrders(int userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      orders = await orderService.getMyOrders(userId);
    } catch (e) {
      error = 'Failed to load orders: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}