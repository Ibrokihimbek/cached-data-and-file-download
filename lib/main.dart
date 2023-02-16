import 'package:cached_vc_download/screens/download/download.dart';
import 'package:cached_vc_download/screens/users/users.dart';
import 'package:cached_vc_download/service/notification_cervise.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    LocalNotificationService.localNotificationService.init(navigatorKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileDownload(),
      navigatorKey: navigatorKey,
    );
  }
}
