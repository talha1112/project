import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/models/walk.dart';

import '../global/colors.dart';
import '../global/conf.dart';
import '../models/user.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'walkerwalkdetails.dart';

class Walkermywalks extends StatefulWidget {
  const Walkermywalks({super.key});

  @override
  _WalkermywalksState createState() => _WalkermywalksState();
}

class _WalkermywalksState extends State<Walkermywalks> {
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

  Future<List<Walk>> getOwnerBids() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response = await http
        .post(Uri.parse("$API_URL/walker-my-walks"), body: {}, headers: {
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
                                'My walks',
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
              Expanded(
                child: FutureBuilder<List<Walk>>(
                  future: getOwnerBids(),
                  //we pass a BuildContext and an AsyncSnapshot object which is an
                  //Immutable representation of the most recent interaction with
                  //an asynchronous computation.
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Walk>? walks = snapshot.data;
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'The walk list is empty',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      } else {
                        return CustomListView(
                          walks!,
                          userId: userId,
                        );
                      }
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
  final String userId;

  const CustomListView(this.walks, {super.key, required this.userId});

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          width: 60,
                          height: 60,
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
                          Container(
                            child: Row(
                              children: [
                                const Text(
                                  'Address: ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                                Text(
                                  '${walk.zip!} ${walk.city!}, ${walk.street!.length > 10 ? '${walk.street!.substring(0, 10)}...' : walk.street!}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],

                              // Text(walk.street.length > 3 ? '${walk.street.substring(0, 3)}...' : walk.street);
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (walk.bidprice != 'none')
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Badge(
                        largeSize: 60,
                        backgroundColor: Colors.green,
                        label: Center(
                          child: Text(
                            '\$ ${walk.bidprice}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  // Text(
                  //   walk.from!,
                  //   style: const TextStyle(color: Colors.black),
                  // ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return SimpleDialog(
          //       children: <Widget>[
          //         SizedBox(
          //           height: 100.0,
          //           width: 100.0,
          //           child: ListView(
          //             children: const <Widget>[
          //               Text(
          //                 "one",
          //                 style: TextStyle(color: Colors.black),
          //               ),
          //               Text("two"),
          //             ],
          //           ),
          //         )
          //       ],
          //     );
          //   },
          // );
          var route = MaterialPageRoute(
            builder: (BuildContext context) =>
                WalkerBidDetails(walk_id: walk.id.toString()),
          );
          Navigator.of(context).push(route);
        });
  }
}
