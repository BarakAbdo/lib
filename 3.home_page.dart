import 'package:flutter/material.dart';
import '1.Login_Page.dart';
import '4.profile_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Products & Services'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Medical User'),
              accountEmail: Text('user@hospital.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('B', style: TextStyle(fontSize: 24, color: Colors.blue)),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Image.network(
                    'https://picsum.photos/200',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text('Medical Item ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(100, 30)),
                    onPressed: () {
                      print('Item ${index + 1} clicked');
                    },
                    child: const Text('عرض التفاصيل', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}