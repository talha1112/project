import 'dart:convert';
import '../main.dart';
import 'dart:typed_data';
import '../global/conf.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/views/ownerbiddetails.dart';
import 'package:test/views/walkbidsprofile.dart';
import 'package:test/views/walkerwalkdetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        _handleMessage(notificationResponse.payload!);
      }
    });
  }

  static Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  static void display(RemoteMessage message) async {
    if (message.data.containsKey('walk_start')) {
      // print('walk_start');

      final context = navigatorKey.currentContext;
      if (context != null) {
        Future token = Provider.of<Auth>(context, listen: false).getToken();
        print('VVVVVVVVVVVVV');
        // print(token);
        FlutterBackgroundService().startService();
        await Future.delayed(const Duration(
            seconds: 1)); // Daj servisu malo vremena da se pokrene
        String wid = message.data['walk_idd'];
        FlutterBackgroundService()
            .invoke("updateData", {"walk_id": wid, "token": await token});
      }

      // FlutterBackgroundService().invoke('setAsBackground');
      // FlutterBackgroundService().invoke('stopService');
      // navigatorKey.currentState?.push(
      //   MaterialPageRoute(
      //     builder: (context) => BidDetails(walk_id: message.data['walk_idd']),
      //   ),
      // );
    }

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      ByteArrayAndroidBitmap? largeIcon;
      ByteArrayAndroidBitmap? bigPicture;

      if (message.data.containsKey('image')) {
        largeIcon = ByteArrayAndroidBitmap(
            await _getByteArrayFromUrl(message.data['image']));
        bigPicture = ByteArrayAndroidBitmap(
            await _getByteArrayFromUrl(message.data['image']));
      }

      final BigPictureStyleInformation? bigPictureStyleInformation =
          bigPicture != null
              ? BigPictureStyleInformation(bigPicture,
                  largeIcon: largeIcon,
                  contentTitle: message.notification!.title,
                  htmlFormatContentTitle: true,
                  summaryText: message.notification!.body,
                  htmlFormatSummaryText: true)
              : null;

      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'big text channel id',
          'big text channel name',
          channelDescription: 'big text channel description',
          styleInformation: bigPictureStyleInformation,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: jsonEncode(message.data));
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<void> saveToken(BuildContext context, String token) async {
    String? accessToken;
    Future aToken = Provider.of<Auth>(context, listen: false).getToken();
    accessToken = await aToken;
    final response = await http.post(Uri.parse('$API_URL/save-token'), body: {
      'token': token,
    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'ok') {
        // print('Token saved successfully');
      } else {
        // print('Failed to save token');
      }
    } else {
      print('Failed to save token with status code: ${response.statusCode}');
    }
  }

  static Future<void> _handleMessage(String payload) async {
    Map<String, dynamic> data = jsonDecode(payload);
    if (data.containsKey('bid_id')) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => Walkerbidprofile(bid_id: data['bid_id']),
        ),
      );
    } else if (data.containsKey('walk_id')) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => WalkerBidDetails(walk_id: data['walk_id']),
        ),
      );
    } else if (data.containsKey('arrived')) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => BidDetails(walk_id: data['arrived']),
        ),
      );
    }
    // else if (data.containsKey('walk_start')) {
    //   print('walk_start');

    //   final context = navigatorKey.currentContext;
    //   if (context != null) {
    //     Future token = Provider.of<Auth>(context, listen: false).getToken();
    //     print('VVVVVVVVVVVVV');
    //     print(token);
    //     FlutterBackgroundService().startService();
    //     await Future.delayed(const Duration(
    //         seconds: 1)); // Daj servisu malo vremena da se pokrene
    //     String wid = data['walk_idd'];
    //     FlutterBackgroundService()
    //         .invoke("updateData", {"walk_id": wid, "token": await token});
    //   }

    //   // FlutterBackgroundService().invoke('setAsBackground');
    //   // FlutterBackgroundService().invoke('stopService');
    //   navigatorKey.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (context) => BidDetails(walk_id: data['walk_idd']),
    //     ),
    //   );
    // }
    // else if (data.containsKey('walkend')) {
    //   FlutterBackgroundService().invoke('stopService');
    //   // FlutterBackgroundService().invoke('setAsBackground');
    //   // FlutterBackgroundService().invoke('stopService');
    //   navigatorKey.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (context) => BidDetails(walk_id: data['walkend']),
    //     ),
    //   );
    // }
  }
}

// FlutterBackgroundService().invoke('setAsBackground');
