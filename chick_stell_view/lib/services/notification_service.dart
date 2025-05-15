import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef NotificationCallback = void Function(String title, String body);

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Callback para usar dentro de la app (como en la pantalla principal)
  static NotificationCallback? onNotificationReceived;

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  /// Muestra una notificación del sistema y también la propaga a la app
  static Future<void> showNotification(
    String title,
    String body, {
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alert_channel',
      'Alertas',
      channelDescription: 'Notificaciones de estrés térmico',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Notificación del sistema
    await _notificationsPlugin.show(id, title, body, notificationDetails);

    // Callback interno para mostrar algo en la app
    if (onNotificationReceived != null) {
      onNotificationReceived!(title, body);
    }
  }
}
