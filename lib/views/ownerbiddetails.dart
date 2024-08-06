import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../global/colors.dart';
import '../global/conf.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'ownerbidlist.dart';
import 'walkbids.dart';

class BidDetails extends StatefulWidget {
  final String walk_id;
  const BidDetails({super.key, required this.walk_id});
  @override
  _BidDetailsState createState() => _BidDetailsState();
}

class _BidDetailsState extends State<BidDetails> {
  Future<Map<String, dynamic>> ownerGetWalkFromPush() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response =
        await http.post(Uri.parse("$API_URL/owner-get-walk-from-push"), body: {
      'walk_id': widget.walk_id,
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

  GoogleMapController? mapController;
  List<LatLng> routeCoordinates = [];

  late Future<Map<String, dynamic>> walk;

  @override
  void initState() {
    super.initState();
    walk = ownerGetWalkFromPush();
    // bid = await ownerGetBidFromPush();
    _fetchCoordinates();
  }

  Future<void> _fetchCoordinates() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response = await http.post(Uri.parse("$API_URL/read-gps"), body: {
      'walk_id': widget.walk_id.toString(),
    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });
    print('response.statusCodeeeeeeeeeeee');
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        routeCoordinates = data.map((item) {
          double lat = double.parse(item['lat']);
          double lon = double.parse(item['lon']);
          return LatLng(lat, lon);
        }).toList();
        print('routeCoordinatessssssssssssssss');
        print(routeCoordinates);
        print(routeCoordinates.toString());
      });
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xffd6e9e8),
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: walk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        color: primary,
                        padding: const EdgeInsets.only(left: 20, top: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
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
                                        'Walk - ${data['walk_id']}',
                                        style: const TextStyle(
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
                      // Container(
                      //   color: primary,
                      //   padding: const EdgeInsets.only(left: 20, top: 30),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       const Expanded(
                      //         flex: 2,
                      //         child: Column(
                      //           // mainAxisAlignment: MainAxisAlignment.start,
                      //           // crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Row(
                      //               // mainAxisAlignment: MainAxisAlignment.start,
                      //               // crossAxisAlignment: CrossAxisAlignment.end,
                      //               children: [
                      //                 Text(
                      //                   'Hello aaaa',
                      //                   style: TextStyle(fontSize: 20),
                      //                 )
                      //               ],
                      //             ),
                      //             Row(
                      //               // mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [Text('My profile')],
                      //             ),
                      //             Row(
                      //               // mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [Text('My walks')],
                      //             ),
                      //             Row(
                      //               // mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [Text('My dog')],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       Expanded(
                      //         flex: 1,
                      //         child: Column(
                      //           children: [
                      //             Image.asset(
                      //               'assets/logo.jpg',
                      //               height: 110,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(width: 10),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Card(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
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
                                              'Name: ${data['dog_name']}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              'Birthday: ${data['dog_birthday']}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              'Weight: ${data['dog_weight']}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 250,
                                              child: Text(
                                                overflow: TextOverflow.fade,
                                                softWrap: true,
                                                'Breed: ${data['dog_breed']}',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.network(
                                              (data['owner_profile_image'] !=
                                                          null &&
                                                      data['owner_profile_image'] !=
                                                          '')
                                                  ? data['owner_profile_image']!
                                                  : 'https://dog.willtaxi.wien/img/noimage.jpg',
                                              width: 100,
                                              height: 100,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 7,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'From: ${data['from']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'To: ${data['to']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Walker: ${data['walker']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Price: ${(data['price'] ?? '')}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Arrived: ${data['arrived']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Walk start: ${data['walk_start']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Returned: ${data['returned']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      'Walk end: ${data['walk_end']}',
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (data['walker_id'] == null)
                                      ElevatedButton(
                                        onPressed: () {
                                          // set up the buttons
                                          Widget cancelButton = TextButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              Future token = Provider.of<Auth>(
                                                      context,
                                                      listen: false)
                                                  .getToken();
                                              final response = await http.post(
                                                  Uri.parse(
                                                      "$API_URL/owner-bid-cancel"),
                                                  body: {
                                                    'walk_id': data['walk_id']
                                                        .toString(),
                                                  },
                                                  headers: {
                                                    'Accept':
                                                        'application/json',
                                                    'Authorization':
                                                        'Bearer ${await token}',
                                                  });
                                              if (response.statusCode == 200) {
                                                // Map<String, dynamic> data = jsonDecode(response.body);
                                                var res =
                                                    json.decode(response.body);
                                                // print('RRRRRRRRRRRRRRRRR');
                                                // print(res);
                                                if (res['status'] == 'ok') {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              const Ownerbidlist())));
                                                }
                                              } else {
                                                throw Exception(
                                                    'We were not able to successfully download the json data.');
                                              }
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: const Text("Attention"),
                                            content: const Text(
                                                "Do you want to continue canceling this offer?"),
                                            actions: [
                                              cancelButton,
                                              continueButton,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  0.0),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 255, 0, 0)),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0), // radius you want
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0), //color
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Text(
                                            'CANCEL',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ),
                                      ),
                                    if (data['count'] != '0')
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Walkbids(
                                                  walkId: data['walk_id']
                                                      .toString(),
                                                ),
                                              ));
                                        },
                                        style: ButtonStyle(
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  0.0),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  primary),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0), // radius you want
                                              side: const BorderSide(
                                                color: primary, //color
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: const Text(
                                            'BIDS',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    if (data['arrived'] != '' &&
                                        data['walk_start'] == '')
                                      ElevatedButton(
                                        onPressed: () {
                                          Widget cancelButton = TextButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              Future token = Provider.of<Auth>(
                                                      context,
                                                      listen: false)
                                                  .getToken();
                                              final response = await http.post(
                                                  Uri.parse(
                                                      "$API_URL/owner-start-walk"),
                                                  body: {
                                                    'walk_id': data['walk_id']
                                                        .toString(),
                                                  },
                                                  headers: {
                                                    'Accept':
                                                        'application/json',
                                                    'Authorization':
                                                        'Bearer ${await token}',
                                                  });
                                              // print(response.statusCode);
                                              if (response.statusCode == 200) {
                                                // Map<String, dynamic> data = jsonDecode(response.body);
                                                var res =
                                                    json.decode(response.body);
                                                // print('RRRRRRRRRRRRRRRRR');
                                                // print(res);
                                                if (res['status'] == 'ok') {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              const Ownerbidlist())));
                                                }
                                              } else {
                                                throw Exception(
                                                    'We were not able to successfully download the json data.');
                                              }
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: const Text("Attention"),
                                            content: const Text(
                                                "Do you want to continue ?"),
                                            actions: [
                                              cancelButton,
                                              continueButton,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  0.0),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  primary),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0), // radius you want
                                              side: const BorderSide(
                                                color: primary, //color
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: const Text(
                                            'WALK START',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    if (data['returned'] != '' &&
                                        data['walk_end'] == '')
                                      ElevatedButton(
                                        onPressed: () {
                                          Widget cancelButton = TextButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              Future token = Provider.of<Auth>(
                                                      context,
                                                      listen: false)
                                                  .getToken();
                                              final response = await http.post(
                                                  Uri.parse(
                                                      "$API_URL/owner-end-walk"),
                                                  body: {
                                                    'walk_id': data['walk_id']
                                                        .toString(),
                                                  },
                                                  headers: {
                                                    'Accept':
                                                        'application/json',
                                                    'Authorization':
                                                        'Bearer ${await token}',
                                                  });
                                              if (response.statusCode == 200) {
                                                // Map<String, dynamic> data = jsonDecode(response.body);
                                                var res =
                                                    json.decode(response.body);
                                                // print('RRRRRRRRRRRRRRRRR');
                                                // print(res);
                                                if (res['status'] == 'ok') {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              const Ownerbidlist())));
                                                }
                                              } else {
                                                throw Exception(
                                                    'We were not able to successfully download the json data.');
                                              }
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: const Text("Attention"),
                                            content: const Text(
                                                "Do you want to continue ?"),
                                            actions: [
                                              cancelButton,
                                              continueButton,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  0.0),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  primary),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0), // radius you want
                                              side: const BorderSide(
                                                color: primary, //color
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: const Text(
                                            'WALK END',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            routeCoordinates.isEmpty
                                ? const Center(child: Text(''))
                                // child: CircularProgressIndicator())
                                : SizedBox(
                                    height: 300,
                                    // width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.height,
                                    child: GoogleMap(
                                      onMapCreated: (controller) {
                                        mapController = controller;
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: routeCoordinates.isNotEmpty
                                            ? routeCoordinates[0]
                                            : const LatLng(0, 0),
                                        zoom: 16.0,
                                      ),
                                      polylines: {
                                        Polyline(
                                          polylineId: const PolylineId('route'),
                                          points: routeCoordinates,
                                          color: Colors.blue,
                                          width: 5,
                                          jointType: JointType.round,
                                        ),
                                      },
                                      markers: routeCoordinates
                                          .map((coordinate) => Marker(
                                                visible: true,
                                                markerId: MarkerId(
                                                    coordinate.toString()),
                                                position: coordinate,
                                              ))
                                          .toSet(),
                                    ),
                                  ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: 2,
                      //     itemBuilder: (context, index) {
                      //       return ListTile(
                      //         title: Text("Item $index"),
                      //         subtitle: Text("Subtitle $index"),
                      //         leading: const Icon(Icons.account_circle),
                      //         trailing: const Icon(Icons.arrow_forward_ios),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
