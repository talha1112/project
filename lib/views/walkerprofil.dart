import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/global/colors.dart';
import 'package:test/models/walker.dart';
import 'package:test/views/walkerprofil_edit.dart';

import '../global/conf.dart';
import '../main.dart';
import '../providers/auth.dart';
import '../services/local_notification_service.dart';
import '../widgets/navdrawer.dart';
import 'ownerbiddetails.dart';
import 'walkbidsprofile.dart';
import 'walkerwalkdetails.dart';

class Walkerprofil extends StatefulWidget {
  const Walkerprofil({super.key});

  @override
  _WalkerprofilState createState() => _WalkerprofilState();
}

class _WalkerprofilState extends State<Walkerprofil> {
  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return const Color(0xfffa8d62);
  }

  Walker? walker;
  bool isLoading = true;

  bool isChecked = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize();
    _firebaseMessaging.getToken().then((token) async {
      LocalNotificationService.saveToken(context, token!);
    });

    FirebaseMessaging.onMessage.listen((message) async {
      // print('Message received in foreground: ${message.data}');
      // print('Message notification: ${message.notification}');

      if (message.data.containsKey('walkend')) {
        FlutterBackgroundService().invoke('stopService');
        // FlutterBackgroundService().invoke('setAsBackground');
        // FlutterBackgroundService().invoke('stopService');
        // navigatorKey.currentState?.push(
        //   MaterialPageRoute(
        //     builder: (context) => BidDetails(walk_id: message.data['walkend']),
        //   ),
        // );
      }

      // if (message.data.containsKey('walk_start')) {
      //   // print('walk_start');

      //   // final context = navigatorKey.currentContext;
      //   // if (context != null) {
      //   Future token = Provider.of<Auth>(context, listen: false).getToken();
      //   // print('VVVVVVVVVVVVV');
      //   // print(token);
      //   FlutterBackgroundService().startService();
      //   await Future.delayed(const Duration(
      //       seconds: 1)); // Daj servisu malo vremena da se pokrene
      //   String wid = message.data['walk_idd'];
      //   FlutterBackgroundService()
      //       .invoke("updateData", {"walk_id": wid, "token": await token});
      //   // }

      //   // FlutterBackgroundService().invoke('setAsBackground');
      //   // FlutterBackgroundService().invoke('stopService');
      //   // navigatorKey.currentState?.push(
      //   //   MaterialPageRoute(
      //   //     builder: (context) => BidDetails(walk_id: message.data['walk_idd']),
      //   //   ),
      //   // );
      // }

      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!');
      _handleMessage(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
    fetchWalkerProfilData();
  }

  Future<void> fetchWalkerProfilData() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();

    final response =
        await http.post(Uri.parse("$API_URL/get-myprofil-walker"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });

    // print(await token);
    // print('response.statusCode');
    // print(response.statusCode);
    // print(response);
    // print(response.toString());
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        walker = Walker.fromJson(data['walker']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    // Upravljanje logikom kada korisnik klikne na notifikaciju
    // print('Message clicked!');
    // print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Notification Title: ${message.notification!.title}');
      print('Notification Body: ${message.notification!.body}');
    }

    // Proveri da li message.data sadrži bid_id
    if (message.data.containsKey('bid_id')) {
      String bidId = message.data['bid_id'];

      // Navigacija na određeni ekran sa bid_id parametrom
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => Walkerbidprofile(bid_id: bidId),
        ),
      );
    }

    // Proveri da li message.data sadrži walk_id
    if (message.data.containsKey('walk_id')) {
      String walkId = message.data['walk_id'];

      // Navigacija na određeni ekran sa walk_id parametrom
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => WalkerBidDetails(walk_id: walkId),
        ),
      );
    }

    if (message.data.containsKey('arrived')) {
      String walkId = message.data['arrived'];

      // Navigacija na određeni ekran sa walk_id parametrom
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => BidDetails(walk_id: walkId),
        ),
      );
    }

    if (message.data.containsKey('walk_start')) {
      print('walk_start');

      // final context = navigatorKey.currentContext;
      // if (context != null) {
      Future token = Provider.of<Auth>(context, listen: false).getToken();
      print('VVVVVVVVVVVVV');
      print(token);
      FlutterBackgroundService().startService();
      await Future.delayed(
          const Duration(seconds: 1)); // Daj servisu malo vremena da se pokrene
      String wid = message.data['walk_idd'];
      FlutterBackgroundService()
          .invoke("updateData", {"walk_id": wid, "token": await token});
      // }

      // FlutterBackgroundService().invoke('setAsBackground');
      // FlutterBackgroundService().invoke('stopService');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => BidDetails(walk_id: message.data['walk_idd']),
        ),
      );
    }
    // Dodaj bilo koju drugu logiku za navigaciju ovde
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset(
        //   "assets/background-login.jpg",
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   fit: BoxFit.cover,
        // ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
          ),
          drawer: const NavDrawer(),
          backgroundColor: const Color(0xffd6e9e8),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: primary,
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'WALKER PROFIL',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )
                              ],
                            ),
                            // Row(
                            //   // mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [Text('My profile')],
                            // ),
                            // Row(
                            //   // mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [Text('My walks')],
                            // ),
                            // Row(
                            //   // mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [Text('My dog')],
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/logo.jpg',
                              height: 110,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                isLoading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        // color: const Color(0xffd6e9e8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${walker?.name!}',
                                  style: const TextStyle(
                                      color: Color(0xff2a636d), fontSize: 30),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    (walker!.profile_image != null &&
                                            walker!.profile_image != '')
                                        ? walker!.profile_image!
                                        : 'https://dog.willtaxi.wien/img/noimage.jpg',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${walker?.city!}',
                                          style: const TextStyle(
                                              color: Color(0xff2a636d),
                                              fontSize: 18),
                                        ),
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          width: 130,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ZIP: ${walker?.zip!}',
                                              style: const TextStyle(
                                                  color: primary, fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Average score: ${walker?.score!}',
                                          style: const TextStyle(
                                              color: Color(0xff2a636d),
                                              fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        if (walker?.trusted == '1')
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/trusted.png',
                                                width: 60,
                                              ),
                                              const Text(
                                                'Trusted walker!',
                                                style: TextStyle(
                                                    color: Color(0xff2a636d),
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        // const Row(
                                        //   children: [
                                        //     Text(
                                        //       'VERIFIED USER',
                                        //       style: TextStyle(
                                        //           color: Color(0xff2a636d),
                                        //           fontSize: 18),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         padding: const EdgeInsets.all(5),
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(5),
                            //           color: Colors.white,
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             Image.asset(
                            //               'assets/chat.png',
                            //               height: 40,
                            //             ),
                            //             const SizedBox(
                            //               width: 10,
                            //             ),
                            //             Image.asset(
                            //               'assets/setac.png',
                            //               height: 40,
                            //             ),
                            //             const SizedBox(
                            //               width: 10,
                            //             ),
                            //             Image.asset(
                            //               'assets/jelka.png',
                            //               height: 40,
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 270,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                const Walkerprofiledit()),
                                      );
                                    },
                                    style: ButtonStyle(
                                      elevation:
                                          WidgetStateProperty.all<double>(0.0),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              const Color(0xFFf67943)),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5.0), // radius you want
                                          side: const BorderSide(
                                            color: Color(0xFFf67943), //color
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: const Text(
                                        'EDIT PROFIL',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
