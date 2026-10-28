import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ProductProvider.dart';
import 'ProductDetailsPage.dart';

class ProductsScreen extends StatefulWidget {
  final int userId;

  const ProductsScreen(this.userId, {super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final String dashboardUrl = 'https://52dcmx2h-7269.inc1.devtunnels.ms';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProductProvider>().fetchProducts()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final productsList = provider.products;

          if (productsList.isEmpty) {
            return const Center(child: Text('No Products Found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              final product = productsList[index];
              final String imagePath = product['imageUrl']?.toString() ?? '';
              final String imageUrl = imagePath.isEmpty
                  ? ''
                  : Uri.parse(dashboardUrl).resolve(imagePath).toString();

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                ),
                              );
                            },
                          )
                              : const Center(
                            child: Icon(
                              Icons.image,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          product['name']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${product['price']} SAR',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}