import 'package:flutter/material.dart';
import '../data/NotificationService.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<dynamic> notifications = [];
  bool isLoading = false;
  String? error;

  Future<void> loadNotifications(int userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      notifications = await _notificationService.getNotifications(userId);

      try {
        await _notificationService.markAllAsRead(userId);
      } catch (_) {}

    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications(int userId) async {
    await loadNotifications(userId);
  }

  void clear() {
    notifications = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}