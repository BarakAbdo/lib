import 'package:flutter/material.dart';
import 'data/CategoryService.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService categoryService = CategoryService();
  late Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    categories = categoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categoriesList = snapshot.data ?? [];

          if (categoriesList.isEmpty) {
            return const Center(child: Text('No Categories Found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              final category = categoriesList[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.category, color: Colors.white),
                  ),
                  title: Text(
                    category['name']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('UID: ${category['uid'] ?? 'N/A'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}