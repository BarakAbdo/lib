import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/NotificationProvider.dart';

class NotificationsScreen extends StatefulWidget {
  final int userId;

  const NotificationsScreen(this.userId, {super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications(widget.userId);
    });
  }

  String _formatDate(String value) {
    if (value.isEmpty) return '';
    final text = value.endsWith('Z') ? value : '${value}Z';
    final d = DateTime.tryParse(text)?.toLocal();
    if (d == null) return value;

    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final items = provider.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Builder(
        builder: (context) {
          if (provider.isLoading && items.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0F172A)));
          }

          if (provider.error != null && items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            );
          }

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 15),
                  Text(
                    'No Notifications Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF0F172A),
            onRefresh: () => provider.refreshNotifications(widget.userId),
            child: ListView.builder(
              // أضفنا هذه الخصائص لضمان عمل الـ Scroll بسلاسة حتى لو كانت العناصر قليلة أو كثيرة
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: false,
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final n = items[index];
                final unread = n['isRead'] == false;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: unread ? const Color(0xFFF8FAFC) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: unread ? const Color(0xFF0D9488).withOpacity(0.4) : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: unread ? const Color(0xFF0D9488).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                unread ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                                color: unread ? const Color(0xFF0D9488) : Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${n['title'] ?? 'Notification'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${n['message'] ?? ''}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatDate('${n['createdAt'] ?? ''}'),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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