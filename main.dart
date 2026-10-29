import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'App2/Providers/NotificationProvider.dart';
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
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF0D9488),
          surface: const Color(0xFFF4F7F6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}