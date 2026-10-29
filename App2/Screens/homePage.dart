import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'CartPage.dart';
import 'CategoriesPage.dart';
import 'NotificationPage.dart';
import 'OrderPage.dart';
import 'ProductPage.dart';
import 'ProfilePage.dart';
import 'loginPage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text(
          'Hospital Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Eng. Barak Ghaleb',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text(
                userProvider.email,
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userProvider.username.isNotEmpty ? userProvider.username[0].toUpperCase() : 'B',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
            ),
            _drawerItem(
              icon: Icons.home_rounded,
              title: 'Home',
              color: const Color(0xFF0F172A),
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              icon: Icons.medical_services_rounded,
              title: 'Products',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsScreen(userProvider.userId)),
                );
              },
            ),
            _drawerItem(
              icon: Icons.category_rounded,
              title: 'Categories',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.shopping_cart_rounded,
              title: 'My Cart',
              color: Colors.indigo,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen(userProvider.userId)),
                );
              },
            ),
            _drawerItem(
              icon: Icons.list_alt_rounded,
              title: 'My Orders',
              color: Colors.teal,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrdersScreen(userProvider.userId)),
                );
              },
            ),
            _drawerItem(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              color: Colors.amber[800]!,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsScreen(userProvider.userId)),
                );
              },
            ),
            _drawerItem(
              icon: Icons.person_rounded,
              title: 'Profile',
              color: Colors.purple,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            const Divider(indent: 16, endIndent: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              ),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
              onTap: () {
                context.read<UserProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF0F172A),
                      child: Icon(Icons.local_hospital_rounded, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome, ${userProvider.username}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'User ID: ${userProvider.userId}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Email: ${userProvider.email}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
      onTap: onTap,
    );
  }
}