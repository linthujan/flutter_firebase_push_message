import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
}

void _handleMessage(RemoteMessage message) {
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
}

Future<http.Response> registerToken(String fcmToken) {
  return http.post(
      Uri.parse(
          'https://tough-terminally-koala.ngrok-free.app/api/firebase/registerToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'fcm_token': fcmToken,
      }));
}

class FirebaseMessager {
  final _firebaseMessager = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // await _firebaseMessager.setAutoInitEnabled(true);
    NotificationSettings settings = await _firebaseMessager.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print("Permission : ${settings.authorizationStatus}");
    // print("Permission : ${settings.sound}");

    //ios
    // await _firebaseMessager.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    final fcmToken = await _firebaseMessager.getToken();

    print('Token: $fcmToken');
    if (Platform.isAndroid) {
      // await registerToken(fcmToken!);
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Title ${message.notification?.title}');
      print('Body ${message.notification?.body}');
      print('Payload ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
