import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../widgets/Audioplayer/audioplayer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fltNotification =
    FlutterLocalNotificationsPlugin();

showNotificationWithDefaultSound(
    {required String title, required String message}) async {
  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics =
      title == 'Missed Call' || title == 'Call Ended'
          ? AndroidNotificationDetails('channel_id', 'channel_name',
              importance: Importance.max,
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound('whistle2'),
              playSound: true,
              ongoing: true,
              visibility: NotificationVisibility.public,
              timeoutAfter: 28000)
          : AndroidNotificationDetails('channel_id', 'channel_name',
              sound: RawResourceAndroidNotificationSound('ringtone'),
              playSound: true,
              ongoing: true,
              importance: Importance.max,
              priority: Priority.high,
              visibility: NotificationVisibility.public,
              timeoutAfter: 28000);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    sound:
        title == 'Missed Call' || title == 'Call Ended' ? '' : 'ringtone.caf',
    presentSound: true,
  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // startMessage();

        fltNotification.show(notification.hashCode, notification.title,
            notification.body, platformChannelSpecifics,
            payload: 'payload');
        final AudioPlayer audioPlayers = AudioPlayer();
        audioPlayers.play("sounds/notification.mp3");
      } else if (notification != null) {
        fltNotification.show(notification.hashCode, notification.title,
            notification.body, platformChannelSpecifics,
            payload: 'payload');
      }
    },
    onDone: () {
      final AudioPlayer audioPlayers = AudioPlayer();
      audioPlayers.stop();
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    try {
      // ignore: unnecessary_null_comparison
      print("data is ${message.data}");
      if (message.data != null || message.data.isNotEmpty) {
        debugPrint("new trip assigned");
        // Get.to(() => const NewRideRequest());
      }
    } catch (e) {
      debugPrint("new trip assigned");
    }
  });

  fltNotification.show(1, "Title", "Body", platformChannelSpecifics,
      payload: 'payload');
}
