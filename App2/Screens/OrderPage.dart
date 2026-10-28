import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/OrderProvider.dart';

class MyOrdersScreen extends StatefulWidget {
  final int userId;

  const MyOrdersScreen(this.userId, {super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<OrderProvider>().fetchMyOrders(widget.userId)
    );
  }

  Future<void> refreshOrders(OrderProvider orderProvider) async {
    await orderProvider.fetchMyOrders(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.indigo,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (orderProvider.error != null) {
            return Center(
              child: Text('Error: ${orderProvider.error}'),
            );
          }

          final items = orderProvider.orders;

          if (items.isEmpty) {
            return const Center(
              child: Text('No Orders Found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => refreshOrders(orderProvider),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];
                final products = order['items'] as List? ?? [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Order #${order['id']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date: ${order['createdAt']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Status: ${order['status']}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Total: ${order['totalAmount']} SAR',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(height: 20),
                        const Text(
                          'Products:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, pIndex) {
                            final product = products[pIndex];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                product['name']?.toString() ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Quantity: ${product['quantity']}',
                              ),
                              trailing: Text(
                                '${product['price']} SAR',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}