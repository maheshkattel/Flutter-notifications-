import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutternotifications/test_page.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //to show notification in app
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //request for permission
  void requestNotificationPermission() async {
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
            alert: true,
            announcement: true,
            sound: true,
            criticalAlert: true,
            carPlay: true,
            badge: true);
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('Enabled by User');
      }
    }
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('Provisional permission by user');
      }
    } else {
      if (kDebugMode) {
        print('User Denied');
      }
    }
  }

  //initialize local notification to show message in app
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitializationSetting = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSetting, iOS: iOSInitializationSetting);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  //initialize message
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      // showNotification(message);
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
      // if (kDebugMode) {
      //   print(message.notification?.title);
      //   print(message.notification?.body);
      // }
    });
  }

  //show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        'High Importance Notification',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'Description of your channel',
            priority: Priority.high,
            importance: Importance.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero);
    _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails);
  }

  //redirect notification to selected screen
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestPage(),
          ));
    }
  }

  //redirect notification to selected screen when offline
  Future<void> setUpInteractMessage(BuildContext context) async {
    //when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  //get token
  Future<String> getToken() async {
    String? token;
    token = await firebaseMessaging.getToken();
    return token!;
  }

  //is token refresh

  void isTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      if (kDebugMode) {
        print('token refreshed and new token is:');
        print(event.toString());
      }
    });
  }
}
