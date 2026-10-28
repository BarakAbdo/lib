import 'package:flutter/material.dart';
import 'data/NotificationService.dart';

class NotificationsScreen extends StatefulWidget {
  final int userId;

  const NotificationsScreen(this.userId, {super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService notificationService = NotificationService();

  late Future<List<dynamic>> notifications;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  void loadNotifications() {
    notifications = notificationService.getNotifications(widget.userId);

    markAsRead();
  }

  Future<void> markAsRead() async {
    try {
      await notificationService.markAllAsRead(widget.userId);
    } catch (_) {}
  }

  Future<void> refreshNotifications() async {
    setState(() {
      loadNotifications();
    });

    await notifications;
  }

  String _formatDate(String value) {
    final text = value.endsWith('Z') ? value : '${value}Z';
    final d = DateTime.tryParse(text)?.toLocal();
    if (d == null) return value;

    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('No Notifications Found'),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshNotifications,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final n = items[index];
                final unread = n['isRead'] == false;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  color: unread ? const Color(0xFFFFF9E6) : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: unread ? Colors.amber : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              unread ? Icons.notifications_active : Icons.notifications_none,
                              color: unread ? Colors.indigo : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${n['title'] ?? 'Notification'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${n['message'] ?? ''}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Date: ${_formatDate('${n['createdAt'] ?? ''}')}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
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