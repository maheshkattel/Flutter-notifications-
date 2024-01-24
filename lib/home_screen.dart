import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutternotifications/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService service = NotificationService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service.requestNotificationPermission();
    service.firebaseInit(context);
    service.getToken().then((value) {
      if (kDebugMode) {
        print('token value is: ');
        print(value);
      }
    });
    service.isTokenRefresh();
    service.setUpInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Notifications Example'),
        ),
      ),
    );
  }
}
