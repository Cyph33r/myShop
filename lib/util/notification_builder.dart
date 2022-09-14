import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationBuilder {
  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails("cyphertech.shop_app.payments", "Payments",
          channelDescription: "Alert for payments",
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority);
  static const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(
          presentAlert: false,
          // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          presentBadge: false,
          // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          presentSound: true,
          // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          sound: null,
          // Specifics the file path to play (only from iOS 10 onwards)
          badgeNumber: null,
          // The application's icon badge number
          attachments: null,
          subtitle: "Alert for payments",
          //Secondary description  (only from iOS 10 onwards)
          threadIdentifier:
              "cyphertech.shop_app.payments" //(only from iOS 10 onwards)
          );
  NotificationDetails platformChannelSpecifics =
      const NotificationDetails(android: androidPlatformChannelSpecifics);

}
