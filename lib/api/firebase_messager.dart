import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
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

Future<http.Response> registerToken(
    String fcmToken, String manufacturer, String model) {
  // print(fcmToken);
  return http.post(
      Uri.parse(
          'https://tough-terminally-koala.ngrok-free.app/api/firebase/registerToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'fcmToken': fcmToken,
        'device': manufacturer + model,
      }));
}

class FirebaseMessager {
  final _firebaseMessager = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessager.requestPermission();
    final fcmToken = await _firebaseMessager.getToken();

    String manufacturer = "";
    String model = "";

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      print("\n");
      print('Device Name: ${androidInfo.manufacturer} ${androidInfo.model}');
      print("\n");
    }

    await registerToken(fcmToken!, manufacturer, model);
    print('Token: $fcmToken');

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
