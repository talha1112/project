import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:test/models/walk.dart';

import '../global/colors.dart';
import '../global/conf.dart';
import '../models/user.dart';
import '../models/zip.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'walkerwalkdetails.dart';

class Walkerbidlist extends StatefulWidget {
  const Walkerbidlist({super.key});

  @override
  _WalkerbidlistState createState() => _WalkerbidlistState();
}

class _WalkerbidlistState extends State<Walkerbidlist> {
  late String fromDate = '';
  late String toDate = '';
  late String userFirstName = '';
  late String userId = '';
  List<Zip> zips = [];
  Zip? selectedZip;
  bool isLoading = true;
  bool filter = false;

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

  Future<void> fetchZips() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();

    final response = await http.post(Uri.parse("$API_URL/get-zips"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });

    if (response.statusCode == 200) {
      // print(json.decode(response.body)['selected_zip']);

      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> dataZips = data['zips'];
      setState(() {
        zips = dataZips.map((json) => Zip.fromJson(json)).toList();

        // selectedZip = zips.firstWhere(
        //     (zip) => zip.id.toString() == walker!.zip_id!,
        //     orElse: () => zips.first);

        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Walk>> getWalkerBids() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response = await http
        .post(Uri.parse("$API_URL/walker-bid-list"), body: {}, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });
    if (response.statusCode == 200) {
      var walks = json.decode(response.body);
      List walkslist = walks['walks'];
      return walkslist.map((walk) => Walk.fromJson(walk)).toList();
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  Future<List<Walk>> getWalkerBidsSearch() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();
    final response =
        await http.post(Uri.parse("$API_URL/walker-bid-list-search"), body: {
      'from': _fromController.text,
      'to': _toController.text,
      'zip_id': (selectedZip != null) ? selectedZip?.id.toString() : '',
    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });
    if (response.statusCode == 200) {
      var walks = json.decode(response.body);
      List walkslist = walks['walks'];
      return walkslist.map((walk) => Walk.fromJson(walk)).toList();
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  late Future<List<Walk>>? walkerBids;

  @override
  void initState() {
    super.initState();
    getUserFirstName();
    fetchZips();
    walkerBids = getWalkerBids();
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
                                'Walk list',
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
                margin: const EdgeInsets.only(top: 10, right: 10, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (filter)
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            controller: _fromController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),

                              fillColor: const Color(0xffaee0d5),
                              prefixIconColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.black),
                              // labelText: 'Birth date',
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                size: 20,
                              ),
                              // enabledBorder: const OutlineInputBorder(
                              //     borderSide: BorderSide.none),
                              // focusedBorder: const OutlineInputBorder(
                              //   borderSide:
                              //       BorderSide(color: Colors.transparent),
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(10),
                              //   ),
                              // ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final DateTime? dateTime =
                                  await showOmniDateTimePicker(
                                context: context,
                                // firstDate: dtime,
                                firstDate: DateTime.now(),
                                is24HourMode: false,
                                // isForce2Digits: true,
                                // isShowSeconds: false,
                                // minutesInterval: 5,
                                // secondsInterval: 60,
                                barrierDismissible: false,
                                type: OmniDateTimePickerType.date,
                              );
                              // debugPrint('dateTime: $dateTime');

                              if (dateTime != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                                String fDate =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                                setState(() {
                                  fromDate = fDate;
                                  // dtime = dateTime;
                                  _fromController.text = formattedDate;
                                  walkerBids = getWalkerBidsSearch();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    if (filter)
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            controller: _toController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),

                              fillColor: const Color(0xffaee0d5),
                              prefixIconColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.black),
                              // labelText: 'Birth date',
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                size: 20,
                              ),
                              // enabledBorder: const OutlineInputBorder(
                              //     borderSide: BorderSide.none),
                              // focusedBorder: const OutlineInputBorder(
                              //   borderSide:
                              //       BorderSide(color: Colors.transparent),
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(10),
                              //   ),
                              // ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final DateTime? dateTime =
                                  await showOmniDateTimePicker(
                                context: context,
                                // firstDate: dtime,
                                firstDate: DateTime.now(),
                                is24HourMode: false,
                                // isForce2Digits: true,
                                // isShowSeconds: false,
                                // minutesInterval: 5,
                                // secondsInterval: 60,
                                barrierDismissible: false,
                                type: OmniDateTimePickerType.date,
                              );
                              // debugPrint('dateTime: $dateTime');

                              if (dateTime != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                                String fDate =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                                setState(() {
                                  toDate = fDate;
                                  // dtime = dateTime;
                                  _toController.text = formattedDate;
                                  walkerBids = getWalkerBidsSearch();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    Container(
                      decoration: const BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: IconButton(
                        icon: (filter)
                            ? const Icon(Icons.filter_alt_off)
                            : const Icon(Icons.filter_alt),
                        color: Colors.white,
                        splashColor: Colors.white,
                        iconSize: 30.0,
                        onPressed: () {
                          setState(() {
                            filter = !filter;

                            if (!filter) {
                              _fromController.text = '';
                              _toController.text = '';
                              fromDate = '';
                              toDate = '';
                              selectedZip = null;

                              walkerBids = getWalkerBids();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (filter)
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 327,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<Zip>(
                                hint: const Text(
                                  'ZIP',
                                  style: TextStyle(color: Colors.white),
                                ),
                                isExpanded: true,
                                value: selectedZip,
                                onChanged: (Zip? newValue) {
                                  setState(() {
                                    selectedZip = newValue!;
                                    walkerBids = getWalkerBidsSearch();

                                    // print(selectedZip!.id);
                                  });
                                },
                                items:
                                    zips.map<DropdownMenuItem<Zip>>((Zip zip) {
                                  return DropdownMenuItem<Zip>(
                                    value: zip,
                                    child: Text(
                                      zip.code!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  // width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(
                                    //   color: Colors.black26,
                                    // ),
                                    color: const Color(0xffaee0d5),
                                  ),
                                  // elevation: 0,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.white,
                                  iconDisabledColor: Colors.white,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  // maxHeight: 200,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffaee0d5),
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    // radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: FutureBuilder<List<Walk>>(
                  future: walkerBids,
                  //we pass a BuildContext and an AsyncSnapshot object which is an
                  //Immutable representation of the most recent interaction with
                  //an asynchronous computation.
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Walk>? walks = snapshot.data;

                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'The bid list is empty',
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
