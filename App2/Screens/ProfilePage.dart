import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import '../providers/ProfileProvider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profileProvider = context.watch<ProfileProvider>(); // مراقبة بروفايدر البروفايل

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userProvider.username.isNotEmpty ? userProvider.username : 'Eng. Barak Ghaleb',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              userProvider.email.isNotEmpty ? userProvider.email : 'barak7244@gmail.com',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Phone Number'),
              subtitle: Text(profileProvider.phone), // جلب الرقم من البروفايدر
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.blue),
              title: const Text('Department'),
              subtitle: Text(profileProvider.department), // جلب القسم من البروفايدر
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}