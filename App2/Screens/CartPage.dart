import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/OrderService.dart';
import '../data/connection.dart';
import '../providers/CartProvider.dart';

class CartScreen extends StatefulWidget {
  final int userId;

  const CartScreen(this.userId, {super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderService orderService = OrderService();
  bool isOrdering = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CartProvider>().fetchCart(widget.userId)
    );
  }

  Future<void> makeOrder() async {
    if (isOrdering) return;

    setState(() {
      isOrdering = true;
    });

    try {
      final orderId = await orderService.makeOrder(widget.userId);

      if (!mounted) return;

      // تحديث السلة عبر الـ Provider لتفريغها بعد الطلب الناجح
      await context.read<CartProvider>().fetchCart(widget.userId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #$orderId created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isOrdering = false;
        });
      }
    }
  }

  Future<void> deleteProduct(CartProvider cartProvider, int productId) async {
    try {
      await cartProvider.removeFromCart(widget.userId, productId);

      if (!mounted) return;

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
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (cartProvider.error != null) {
            return Center(
              child: Text('Error: ${cartProvider.error}'),
            );
          }

          final items = cartProvider.cartItems;

          if (items.isEmpty) {
            return const Center(
              child: Text('Your Cart is Empty'),
            );
          }

          double total = 0;
          for (var item in items) {
            total += (item['price'] as num).toDouble() *
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
                            deleteProduct(cartProvider, item['productId']);
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isOrdering ? null : makeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: isOrdering
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Make Order',
                      style: TextStyle(fontSize: 18),
                    ),
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