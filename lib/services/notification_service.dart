import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/route_model.dart';
import '../models/leg_model.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    final settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle navigation when tapped
      },
    );
  }

  Future<void> scheduleArrivalAlert(
      RouteModel route, LegModel alightLeg) async {
    // We will schedule a simple notification 10 seconds from now for demo purposes.
    final id = route.id.hashCode & 0x7fffffff;
    final now = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    await _plugin.zonedSchedule(
      id,
      'قربت',
      'ستصل إلى محطة النزول خلال دقيقتين',
      now,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alex_channel',
          'Alex Transit',
          channelDescription: 'Arrival alerts',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAlert(int id) async {
    await _plugin.cancel(id);
  }
}
