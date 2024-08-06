import 'dart:convert';
import '../global/conf.dart';
import '../global/colors.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'package:test/models/bid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/views/walkbidsprofile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Walkbids extends StatefulWidget {
  final String walkId;
  const Walkbids({super.key, required this.walkId});

  @override
  _WalkbidsState createState() => _WalkbidsState();
}

class _WalkbidsState extends State<Walkbids> {
  late Future<List<Bid>> reloadList;
  Future<List<Bid>> getOwnerBids() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response =
        await http.post(Uri.parse("$API_URL/owner-walk-bids"), body: {
      'walkId': widget.walkId,
    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });
    if (response.statusCode == 200) {
      // Map<String, dynamic> data = jsonDecode(response.body);
      var bids = json.decode(response.body);
      List bidsslist = bids['bids'];
      return bidsslist.map((bid) => Bid.fromJson(bid)).toList();
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  @override
  void initState() {
    super.initState();
    reloadList = getOwnerBids();

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (message.data.containsKey('bid_id')) {
          setState(() {
            reloadList = getOwnerBids();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xffd6e9e8),
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      body: Column(
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
                            'Bids',
                            style: TextStyle(fontSize: 20, color: Colors.white),
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
          FutureBuilder<List<Bid>>(
            future: reloadList,
            //we pass a BuildContext and an AsyncSnapshot object which is an
            //Immutable representation of the most recent interaction with
            //an asynchronous computation.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Bid>? bids = snapshot.data;
                return CustomListView(bids!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              //return  a circular progress indicator.
              return Container(
                margin: const EdgeInsets.only(top: 50),
                child: const Center(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator())),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Bid> bids;

  const CustomListView(this.bids, {super.key});

  @override
  Widget build(context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: bids.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(bids[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Bid bid, BuildContext context) {
    return ListTile(
        title: Center(
          child: Card(
            color: Colors.white,
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
                        if (bid.profile_image != '')
                          Image.network(
                            bid.profile_image!,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bid.walker_name!,
                                style:
                                    const TextStyle(color: Color(0xFF000000)),
                              ),
                              if (bid.trusted == '1')
                                Image.asset(
                                  'assets/trusted.png',
                                  width: 30,
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '\$ ${bid.total!}',
                                style:
                                    const TextStyle(color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Average score: ${bid.score! == '0.0' ? 'N/A' : bid.score!}",
                                style:
                                    const TextStyle(color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                        ],
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
          // print('555555555555');
          // print(bid.id.toString());
          var route = MaterialPageRoute(
            // builder: (BuildContext context) => Walkerbidprofile(value: walk),
            builder: (BuildContext context) =>
                Walkerbidprofile(bid_id: bid.id.toString()),
          );
          Navigator.of(context).push(route);

          // var route = MaterialPageRoute(
          //   builder: (BuildContext context) => BidDetails(value: walk),
          // );
          // Navigator.of(context).push(route);

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
          // var route = MaterialPageRoute(
          //   builder: (BuildContext context) => BidDetails(value: walk),
          // );
          // Navigator.of(context).push(route);
        });
  }
}
