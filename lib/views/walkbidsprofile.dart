import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/global/colors.dart';
import 'package:test/global/conf.dart';

import '../providers/auth.dart';
import '../widgets/custom_snack_bar.dart';
import 'ownerbidlist.dart';

class Walkerbidprofile extends StatefulWidget {
  final String bid_id;
  const Walkerbidprofile({
    super.key,
    required this.bid_id,
  });

  @override
  _WalkerbidprofileState createState() => _WalkerbidprofileState();
}

class _WalkerbidprofileState extends State<Walkerbidprofile> {
  // Future<dynamic> ownerGetBidFromPush() async {
  Future<Map<String, dynamic>> ownerGetBidFromPush() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response =
        await http.post(Uri.parse("$API_URL/owner-get-bid-from-push"), body: {
      'bid_id': widget.bid_id,
    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      // Map<String, dynamic> data = jsonDecode(response.body);
      var bidx = json.decode(response.body);
      return bidx;
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  late Future<Map<String, dynamic>> bid;

  @override
  void initState() {
    super.initState();
    bid = ownerGetBidFromPush();
    // bid = await ownerGetBidFromPush();
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
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: const Color(0xffd6e9e8),
          resizeToAvoidBottomInset: false,
          body: FutureBuilder<Map<String, dynamic>>(
            future: bid,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
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
                                      'Walker\'s bid',
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
                    Container(
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
                                data['walker_name'],
                                // futureData['walker_name'],
                                // 'aaaa',
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
                                  data['walker_profile_image']!,
                                  // 'asasasas',
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
                                      const Text(
                                        'Price',
                                        style: TextStyle(
                                            color: Color(0xff2a636d),
                                            fontSize: 18),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${data['total']}\$",
                                            // "ggggg",
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
                                        "Average score: ${data['score'] == '0.0' ? 'N/A' : data['score']}",
                                        // "jjjjj",
                                        style: const TextStyle(
                                            color: Color(0xff2a636d),
                                            fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (data['trusted'] == '1')
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
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 270,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Future token = Provider.of<Auth>(context,
                                            listen: false)
                                        .getToken();
                                    // print('FFFFFFFFF');
                                    // print(data['fee']);
                                    // print(data['total']);
                                    // print(data['bid_id']);
                                    final response = await http.post(
                                        Uri.parse("$API_URL/owner-accept-bid"),
                                        body: {
                                          'fee': data['fee'],
                                          'total': data['total'],
                                          'bid_id': data['bid_id'].toString(),
                                        },
                                        headers: {
                                          'Accept': 'application/json',
                                          'Authorization':
                                              'Bearer ${await token}',
                                        });
                                    // print(response.statusCode);
                                    if (response.statusCode == 200) {
                                      // Map<String, dynamic> data = jsonDecode(response.body);
                                      var res = json.decode(response.body);
                                      // print('RRRRRRRRRRRRRRRRR');
                                      // print(res);
                                      if (res['status'] == 'ok') {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const Ownerbidlist())));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(customSnackBar(
                                                context, res['message'], true));
                                      }
                                    } else {
                                      throw Exception(
                                          'We were not able to successfully download the json data.');
                                    }
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
                                      'ACCEPT',
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
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ],
    );
  }
}
