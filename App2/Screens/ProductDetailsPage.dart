import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/connection.dart';
import '../providers/UserProvider.dart';
import '../providers/ProductDetailsProvider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic product;

  const ProductDetailsScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final String imagePath = product['imageUrl']?.toString() ?? '';
    final String imageUrl = imagePath.isEmpty
        ? ''
        : Uri.parse(ConnectionString.dashboardUrl).resolve(imagePath).toString();

    final detailsProvider = context.watch<ProductDetailsProvider>();

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
                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: detailsProvider.isLoading
                        ? null
                        : () async {
                      final userId = context.read<UserProvider>().userId;
                      final productId = product['id'];

                      final success = await detailsProvider.addToCart(userId, productId);

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product Added to Cart'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${detailsProvider.error}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: detailsProvider.isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Add to Cart'),
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