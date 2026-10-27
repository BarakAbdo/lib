
import 'package:flutter/material.dart';
import 'data/CartService.dart';
import 'data/conncetion.dart';

class CartScreen extends StatefulWidget {
  final int userId;

  const CartScreen(this.userId, {super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();

  late Future<List<dynamic>> cartItems;



  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() {
    cartItems = cartService.getCart(widget.userId);
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await cartService.removeFromCart(
        widget.userId,
        productId,
      );

      if (!mounted) return;

      setState(() {
        loadCart();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product removed from cart'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.indigo,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('Your Cart is Empty'),
            );
          }

          double total = 0;

          for (var item in items) {
            total +=
                (item['price'] as num).toDouble() *
                    (item['quantity'] as num).toInt();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    final String imagePath =
                        item['imageUrl']?.toString() ?? '';

                    final String imageUrl = imagePath.isEmpty
                        ? ''
                        : Uri.parse(ConnectionString.dashboardUrl)
                        .resolve(imagePath)
                        .toString();

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: SizedBox(
                          width: 65,
                          height: 65,
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image);
                            },
                          )
                              : const Icon(Icons.image),
                        ),

                        title: Text(
                          item['name']?.toString() ?? '',
                        ),

                        subtitle: Text(
                          '${item['price']} SAR\n'
                              'Quantity: ${item['quantity']}',
                        ),

                        isThreeLine: true,

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteProduct(item['productId']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Text(
                  'Total: ${total.toStringAsFixed(2)} SAR',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}