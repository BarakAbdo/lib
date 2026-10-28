import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {

  String department = 'General Surgery';
  String phone = '+966 553825368';
  bool isLoading = false;
  String? error;

  void updateProfile(String newDepartment, String newPhone) {
    department = newDepartment;
    phone = newPhone;
    notifyListeners();
  }
}