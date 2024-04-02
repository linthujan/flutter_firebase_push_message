import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
}

class FirebaseMessager {
  final _firebaseMessager = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessager.requestPermission();

    final fcmToken = await _firebaseMessager.getToken();
    print('Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
