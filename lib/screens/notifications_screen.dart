import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/models/notification_model.dart';
import 'package:application/controllers/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications from the database if needed
    // Provider.of<NotificationController>(context, listen: false).fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              NotificationModel notification = controller.notifications[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    notification.message ?? 'No Message',
                    style: TextStyle(
                      fontWeight: notification.isRead == true
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    notification.createdAt ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(
                    notification.isRead == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: notification.isRead == true
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onTap: () {
                    // Mark as read
                    _markAsRead(context, notification);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Mark Notification as Read
  void _markAsRead(BuildContext context, NotificationModel notification) {
    if (notification.isRead == false) {
      NotificationModel updatedNotification = NotificationModel(
        id: notification.id,
        message: notification.message,
        createdAt: notification.createdAt,
        userId: notification.userId,
        isRead: true,
      );

      Provider.of<NotificationController>(context, listen: false)
          .updateNotification(notification.id!, updatedNotification);
    }
  }
}
