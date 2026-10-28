import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'App2/Screens/loginPage.dart';
import 'App2/providers/CartProvider.dart';
import 'App2/providers/OrderProvider.dart';
import 'App2/providers/UserProvider.dart';
import 'App2/providers/ProductProvider.dart';
import 'App2/providers/ProductDetailsProvider.dart';
import 'App2/providers/ProfileProvider.dart';
import 'App2/providers/CategoryProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => ProductDetailsProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const HospitalManagementApp(),
    ),
  );
}

class HospitalManagementApp extends StatelessWidget {
  const HospitalManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}