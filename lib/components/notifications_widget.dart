import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/models/notification.dart' as notification;

// TODO : fetch real data
// TODO : show in overlay
class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  final Future<List<notification.Notification>> _notificationsFuture =
      NotificationService.getAllNotifications();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
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
                        color: Color(CustomColors.raw['primaryBg']!),
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
                              content: Text('Notification deleted'),
                            ),
                          );
                          setState(() {});
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
                    color: Color(CustomColors.raw['primaryBg']!),
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
