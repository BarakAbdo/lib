
import 'package:flutter/material.dart';
import 'data/OrderService.dart';

class MyOrdersScreen extends StatefulWidget {
  final int userId;

  const MyOrdersScreen(this.userId, {super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderService orderService = OrderService();

  late Future<List<dynamic>> orders;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    orders = orderService.getMyOrders(widget.userId);
  }

  Future<void> refreshOrders() async {
    setState(() {
      loadOrders();
    });

    await orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: orders,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
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
              child: Text('No Orders Found'),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshOrders,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];
                final products = order['items'] as List? ?? [];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),

                        Text(
                          'Status: ${order['status']}',
                        ),

                        Text(
                          'Total: ${order['totalAmount']} SAR',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const Divider(),

                        const Text(
                          'Products:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        ...products.map((product) {
                          return ListTile(
                            title: Text(
                              product['name']?.toString() ?? '',
                            ),
                            subtitle: Text(
                              'Quantity: ${product['quantity']}',
                            ),
                            trailing: Text(
                              '${product['price']} SAR',
                            ),
                          );
                        }),

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