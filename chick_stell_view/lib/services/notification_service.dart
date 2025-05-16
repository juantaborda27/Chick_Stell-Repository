import 'package:chick_stell_view/controllers/notificacion_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  /// Muestra una notificación única por ID (por ejemplo, por galpón)
  static Future<void> showNotification(
    String title,
    String body, {
    int id = 0,
  }) async {
    // Verificar si la notificación está activa
    final NotificacionController notificacionController = Get.find<NotificacionController>();
    if (!notificacionController.notificacionesActivas.value) return;
    
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

    await _notificationsPlugin.show(
      id,     // ← ID único para evitar sobrescribir
      title,
      body,
      notificationDetails,
    );
  }
}
