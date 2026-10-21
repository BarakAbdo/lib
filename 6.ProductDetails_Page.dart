import 'package:flutter/material.dart';
import 'package:hospital_management_system/data/conncetion.dart';

import 'data/CartService.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic product;

  final int userId;

  const ProductDetailsScreen(this.product,this.userId, {super.key});


  @override
  Widget build(BuildContext context) {

    final String imagePath = product['imageUrl']?.toString() ?? '';
    final String imageUrl = imagePath.isEmpty
        ? ''
        : Uri.parse(ConnectionString.dashboardUrl).resolve(imagePath).toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 100,
                  );
                },
              )
                  : const Icon(
                Icons.image,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${product['price']} SAR',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 15),
                  Text(
                    'Category Name: ${product['categoryName'] ?? 'غير مصنف'}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await CartService().addToCart(
                          userId,
                          product['id'],
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product Added to Cart'),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}