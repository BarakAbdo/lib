import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import '../providers/ProfileProvider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF0F172A),
              child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              userProvider.username.isNotEmpty ? userProvider.username : 'Eng. Barak Ghaleb',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              userProvider.email.isNotEmpty ? userProvider.email : 'barak7244@gmail.com',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 35),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_rounded, color: Color(0xFF0F172A)),
                ),
                title: const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(profileProvider.phone, style: TextStyle(color: Colors.grey[600])),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_hospital_rounded, color: Color(0xFF0F172A)),
                ),
                title: const Text('Department', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(profileProvider.department, style: TextStyle(color: Colors.grey[600])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}