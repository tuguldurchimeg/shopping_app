import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessage {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // app ehelehed notification ilgeeh huselt asuuna
    await firebaseMessaging.requestPermission();
    final FCMtoken = await firebaseMessaging
        .getToken(); // msg yvuulah bolomjit token
    debugPrint('Token: $FCMtoken');
    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }

  void handleNotification(RemoteMessage? message) {
    if (message == null) return;
    debugPrint('title: ${message.notification?.title.toString()}');
    debugPrint('body: ${message.notification?.body.toString()}');
  }
}
