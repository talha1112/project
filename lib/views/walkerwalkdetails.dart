import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../global/colors.dart';
import '../global/conf.dart';
import '../providers/auth.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/custom_textformfiled _price.dart';
import '../widgets/navdrawer.dart';
import 'walkerbidlist.dart';

class WalkerBidDetails extends StatefulWidget {
  final String walk_id;

  const WalkerBidDetails({super.key, required this.walk_id});
  @override
  _WalkerBidDetailsState createState() => _WalkerBidDetailsState();
}

class _WalkerBidDetailsState extends State<WalkerBidDetails> {
  Future<Map<String, dynamic>> walkerGetWalkFromPush() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response =
        await http.post(Uri.parse("$API_URL/walker-get-walk-from-push"), body: {
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

  late Future<Map<String, dynamic>> walk;
  bool isCheckedPermission = true;

  @override
  void initState() {
    super.initState();
    walk = walkerGetWalkFromPush();
    // bid = await ownerGetBidFromPush();

    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      _showLocationPermissionDialog();
    } else {
      _checkLocationService();
    }
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
    } else {
      // Lokacija je omogućena i dozvola je data
      setState(() {
        isCheckedPermission = false;
      });
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs location access to function properly. Please grant location permission.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Grant Permission'),
              onPressed: () async {
                Navigator.of(context).pop();
                var status = await Permission.location.request();
                if (status.isGranted) {
                  _checkLocationService();
                } else if (status.isPermanentlyDenied) {
                  openAppSettings();
                } else {
                  _showLocationPermissionDialog();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Location Service'),
          content: const Text('Please enable location service to use the app.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Enable'),
              onPressed: () async {
                Navigator.of(context).pop();
                bool serviceEnabled = await Geolocator.openLocationSettings();
                if (serviceEnabled) {
                  _checkLocationService();
                } else {
                  _showLocationServiceDialog();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController price = TextEditingController();

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
          if (snapshot.connectionState == ConnectionState.waiting &&
              isCheckedPermission) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: $snapshot'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
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
                                        'Walk',
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
                                                // maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
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
                                                      'Price: ${data['price'] ?? ''}',
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
                                    if (data['bidprice'] == 'none')
                                      Container(
                                        width: 130,
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: CustomTextFormFieldPrice(
                                          email: price,
                                          label: 'Price',
                                          hint: '10',
                                        ),
                                      ),
                                    if (data['bidprice'] == 'none')
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
                                                      "$API_URL/walker-send-bid"),
                                                  body: {
                                                    'walk_id': data['walk_id']
                                                        .toString(),
                                                    'price': price.text,
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
                                                              const Walkerbidlist())));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          customSnackBar(
                                                              context,
                                                              'Error',
                                                              true));
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
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'SEND BID',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (data['bidprice'] != 'none')
                                      Text("Price: ${data['bidprice']}"),
                                    if (data['bidprice'] != 'none' &&
                                        data['price'] != null &&
                                        data['walk_start'] == '')
                                      ElevatedButton(
                                        onPressed: () async {
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
                                                      "$API_URL/walker-arrived"),
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
                                                              const Walkerbidlist())));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          customSnackBar(
                                                              context,
                                                              res['message'],
                                                              true));
                                                }
                                              } else {
                                                throw Exception(
                                                    'We were not able to successfully download the json data.');
                                              }
                                            },
                                          );
                                          // _checkLocationPermission();

                                          var status =
                                              await Permission.location.status;
                                          if (status.isDenied ||
                                              status.isPermanentlyDenied) {
                                            _showLocationPermissionDialog();
                                          } else {
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
                                          }
                                          // set up the AlertDialog
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
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'I HAVE ARRIVED',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (data['walk_start'] != '' &&
                                        data['walk_end'] == '')
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
                                                      "$API_URL/walker-returned"),
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
                                                              const Walkerbidlist())));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          customSnackBar(
                                                              context,
                                                              res['message'],
                                                              true));
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
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'WE RETURNED',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
