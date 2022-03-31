import 'package:dresscode/models/notification.dart';

// TODO : swap by a real implementation
class NotificationService {
  static Future<List<Notification>> getAllNotifications() async {
    return await Future.delayed(
      Duration.zero,
      () {
        return List.generate(
          20,
          (index) => Notification(
            title: 'Notification $index',
            content: 'content',
          ),
        );
      },
    );
  }

  static Future<void> deleteNotification(Notification notification) async {}
}
