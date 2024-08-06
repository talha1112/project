import 'dart:async';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/views/ownerprofil.dart';
import 'package:test/views/walkerprofil.dart';

import 'global/conf.dart';
import 'providers/auth.dart';
import 'services/local_notification_service.dart';
import 'views/login.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAHUXVLM0UDvp6LkygFxGUSjoceZshfOXs',
    appId: '1:655709702351:android:0a88c46aac7ff6d80f4fba',
    messagingSenderId: '655709702351',
    projectId: 'waggywalkerapp',
    storageBucket: 'waggywalkerapp.appspot.com',
  ));
  print("Handling a background message: ${message.messageId}");

  if (message.data.containsKey('walk_start')) {
    FlutterBackgroundService().startService();
    await Future.delayed(
        const Duration(seconds: 1)); // Daj servisu malo vremena da se pokrene
    String wid = message.data['walk_idd'];
    // Pretpostavimo da možeš pristupiti tokenu direktno, možda iz shared preferences ili slično
    // Future? token = await getTokenFromSomewhere();
    String? token = await Auth.getStaticToken();
    if (token != null) {
      FlutterBackgroundService()
          .invoke("updateData", {"walk_id": wid, "token": token});
    }
  }

  LocalNotificationService.display(message);
}

Future<Future?> getTokenFromSomewhere() async {
  final context = navigatorKey.currentContext;
  // if (context != null) {
  Future token = Provider.of<Auth>(context!, listen: false).getToken();
  // }
  return await token;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAHUXVLM0UDvp6LkygFxGUSjoceZshfOXs',
    appId: '1:655709702351:android:0a88c46aac7ff6d80f4fba',
    messagingSenderId: '655709702351',
    projectId: 'waggywalkerapp',
    storageBucket: 'waggywalkerapp.appspot.com',
  ));
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  LocalNotificationService.initialize();
  await initializeService();

  runApp(ChangeNotifierProvider(
    create: ((context) => Auth()),
    child: const MyApp(),
  ));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  // service.startService();
}

void getLocation(walkId, token) async {
  print('token');
  print(token);
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
  print(position.latitude);
  print(position.longitude);
  print(walkId);
  print('HHHHHHHHHHHHH');

  final response = await http.post(Uri.parse("$API_URL/write-gps"), body: {
    'lon': position.longitude.toString(),
    'lat': position.latitude.toString(),
    'walk_id': walkId.toString(),
  }, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  print(response.statusCode);
  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to load data');
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  String walkId = '';
  String token = '';
  service.on('updateData').listen((event) {
    walkId = event!["walk_id"];
    token = event["token"];
    print('Received variable: $walkId');
    print('Received variable: $token');
  });

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    // print('test');
    getLocation(walkId, token);
  });
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Lemon',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black),
          bodySmall: TextStyle(fontSize: 12.0, color: Colors.black),
          labelLarge: TextStyle(fontSize: 20.0, color: Colors.black),
          labelMedium: TextStyle(fontSize: 18.0, color: Colors.black),
          labelSmall: TextStyle(fontSize: 16.0, color: Colors.black),
          headlineLarge: TextStyle(fontSize: 26.0, color: Colors.black),
          headlineMedium: TextStyle(fontSize: 20.0, color: Colors.black),
          headlineSmall: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = const FlutterSecureStorage();
  late String? key = '';
  void _attemptAuthentication() async {
    final String? keyx = await storage.read(key: 'auth');
    setState(() {
      key = keyx;
      print('KEYYYYYYYYYYYYYYYYY');
      print(key);
    });
  }

  @override
  void initState() {
    super.initState();
    _attemptAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).attempt(key),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final auth = Provider.of<Auth>(context);
          return auth.authenticated
              ? (auth.isWalker)
                  ? const Walkerprofil()
                  : const Ownerprofil()
              : const Login();
        }
      },
    );

    // return Scaffold(
    //   body: Center(
    //     child: Consumer<Auth>(
    //       builder: (context, value, child) {
    //         if (value.authenticated) {
    //           if (value.isWalker) {
    //             return const Walkerprofil();
    //           } else {
    //             return const Ownerprofil();
    //           }
    //         } else {
    //           return const Login();
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}
