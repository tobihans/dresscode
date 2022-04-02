import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/models/notification.dart' as notification;

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late Future<List<notification.Notification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationService.getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: const Center(
            child: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          margin: const EdgeInsets.only(top: 10),
        ),
        Container(
          child: const Center(
            child: Text(
              'Glisser vers la gauche pour supprimer.',
            ),
          ),
          margin: const EdgeInsets.only(top: 10, bottom: 35),
        ),
        Flexible(
          child: FutureBuilder<List<notification.Notification>>(
            future: _notificationsFuture,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                final notifications = snapshot.data!;
                if (notifications.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucune notification',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: notifications.length,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      child: ListTile(
                        title: Text(
                          notifications[index].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(notifications[index].content),
                      ),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 15),
                      ),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await NotificationService.deleteNotification(
                              notifications[index]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text('Notification deleted'),
                            ),
                          );
                          setState(() {
                            _notificationsFuture =
                                NotificationService.getAllNotifications();
                          });
                        }
                      },
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return const Divider();
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Une erreur s\'est produite 🥲',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(CustomColors.raw['primary']!),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
