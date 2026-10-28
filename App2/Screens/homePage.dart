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
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Eng. Barak Ghaleb'),
              accountEmail: Text(userProvider.email),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.blue),
              title: const Text('Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsScreen(userProvider.userId),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.category, color: Colors.orange),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.indigo),
              title: const Text('My Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(userProvider.userId),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.teal),
              title: const Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOrdersScreen(userProvider.userId),
                  ),
                );
              },
            ),

            // **إضافة زر الإشعارات هنا في القائمة الجانبية**
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.amber),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(userProvider.userId),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person, color: Colors.purple),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),


            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text('Logout'),
              onTap: () {
                context.read<UserProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Ya ${userProvider.username}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            Text(
              'User ID: ${userProvider.userId}',
            ),
            Text(
              'Email: ${userProvider.email}',
            ),
          ],
        ),
      ),
    );
  }
}