import 'dart:convert';
import '../global/conf.dart';
import '../models/user.dart';
import 'ownerbiddetails.dart';
import '../global/colors.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:test/models/walk.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Ownerbidlist extends StatefulWidget {
  const Ownerbidlist({super.key});

  @override
  _OwnerbidlistState createState() => _OwnerbidlistState();
}

class _OwnerbidlistState extends State<Ownerbidlist> {
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

  late String userFirstName = '';
  late String userId = '';

  Future<void> getUserFirstName() async {
    try {
      User? usr = Provider.of<Auth>(context, listen: false).user;
      setState(() {
        // debugPrint(usr.toString());
        userFirstName = usr!.name!;
        userId = usr.id!;
      });
    } catch (e) {
      print('error :$e');
    }
  }

  late Future<List<Walk>> reloadList;
  Future<List<Walk>> getOwnerBids() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response = await http
        .post(Uri.parse("$API_URL/owner-bid-list"), body: {}, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });
    if (response.statusCode == 200) {
      // Map<String, dynamic> data = jsonDecode(response.body);
      var walks = json.decode(response.body);
      List walkslist = walks['walks'];
      return walkslist.map((walk) => Walk.fromJson(walk)).toList();
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserFirstName();
    reloadList = getOwnerBids();
    FirebaseMessaging.onMessage.listen((message) {
      // print('Message received in foreground: ${message.data}');
      // print('Message notification: ${message.notification}');
      // print('777777777777777777');
      // print((Ownerbidlist).toString());
      if (message.notification != null) {
        if (message.data.containsKey('bid_id')) {
          setState(() {
            reloadList = getOwnerBids();
          });
          // Navigator.push(
          //   context,
          //   PageRouteBuilder(pageBuilder: (_, __, ___) => const Ownerbidlist()),
          // );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
      ),
      backgroundColor: const Color(0xffd6e9e8),
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      body: Container(
        child: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
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
                                'Walk list ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          ),
                          // const Row(
                          //   // mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [Text('My profile')],
                          // ),
                          // const Row(
                          //   // mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [Text('My walks')],
                          // ),
                          // const Row(
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
              Expanded(
                child: FutureBuilder<List<Walk>>(
                  future: reloadList,
                  //we pass a BuildContext and an AsyncSnapshot object which is an
                  //Immutable representation of the most recent interaction with
                  //an asynchronous computation.
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Walk>? walks = snapshot.data;
                      return CustomListView(walks!);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    //return  a circular progress indicator.
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Walk> walks;

  const CustomListView(this.walks, {super.key});

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: walks.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(walks[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Walk walk, BuildContext context) {
    return ListTile(
        title: Center(
          child: Card(
            color: walk.cancel != null
                ? const Color.fromARGB(255, 255, 200, 196)
                : Colors.white,
            elevation: 1.0,
            child: Container(
              // decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(5.0),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Image.network(
                          (walk.owner!.profile_image != null &&
                                  walk.owner!.profile_image != '')
                              ? walk.owner!.profile_image!
                              : 'https://dog.willtaxi.wien/img/noimage.jpg',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // width: 200,
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                walk.dog!.name!,
                                style:
                                    const TextStyle(color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                          SizedBox(
                            // width: 200,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'FROM: ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                                Text(
                                  walk.from!,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                const Text(
                                  'TO: ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                                Text(
                                  walk.to!,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          if (walk.walkerId != 0)
                            Container(
                              child: Row(
                                children: [
                                  const Text(
                                    'WALKER: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  Text(
                                    walk.walker != null
                                        ? walk.walker!.name!
                                        : '',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Text(
                  //   walk.from!,
                  //   style: const TextStyle(color: Colors.black),
                  // ),

                  if (walk.walkerId == 0)
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Badge(
                        largeSize: 30,
                        backgroundColor:
                            walk.count == '0' ? Colors.red : Colors.green,
                        label: Center(
                          child: Text(
                            walk.count!,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),

                  if (walk.walkerId != 0)
                    const SizedBox(
                      height: 30,
                      width: 30,
                      child: Badge(
                        largeSize: 30,
                        backgroundColor: Colors.green,
                        label: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          // print('DDDDDDDDDD');
          // print(walk.id.toString());
          var route = MaterialPageRoute(
            builder: (BuildContext context) =>
                BidDetails(walk_id: walk.id.toString()),
          );

          Navigator.of(context).push(route);
        });
  }
}
