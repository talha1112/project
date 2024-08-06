import '../helper/dio.dart';
import '../models/user.dart';
import '../models/error.dart';
import 'package:intl/intl.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/global/colors.dart';
import '../widgets/custom_snack_bar.dart';
import 'package:test/views/ownerbidlist.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Ownercreatebid extends StatefulWidget {
  const Ownercreatebid({super.key});

  @override
  _OwnercreatebidState createState() => _OwnercreatebidState();
}

class _OwnercreatebidState extends State<Ownercreatebid> {
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

  bool isChecked = false;
  late String userFirstName = '';
  late String userId = '';
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  late String startDate = '';
  late String endDate = '';
  DateTime dtime = DateTime.now();
  ValidationErrorCreateBid? _validationErrorCreateBid;

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

  @override
  void initState() {
    super.initState();
    getUserFirstName();
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: const Color(0xffd6e9e8),
          resizeToAvoidBottomInset: false,
          drawer: const NavDrawer(),
          body: Column(
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
                                'Create walk',
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
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Baf',
                          style:
                              TextStyle(color: Color(0xff2a636d), fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.network(
                          'https://dog.willtaxi.wien/img/vlasnik.jpg',
                          width: 100,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _startDateController,
                              decoration: const InputDecoration(
                                fillColor: primary,
                                prefixIconColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                labelText: 'Start date',
                                filled: true,
                                prefixIcon: Icon(Icons.calendar_today),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? dateTime =
                                    await showOmniDateTimePicker(
                                  context: context,
                                  firstDate: dtime,
                                  is24HourMode: false,
                                  isShowSeconds: false,
                                  minutesInterval: 5,
                                  secondsInterval: 60,
                                );
                                // debugPrint('dateTime: $dateTime');

                                if (dateTime != null) {
                                  String formattedDate = DateFormat('y-M-d')
                                      .add_jm()
                                      .format(dateTime);
                                  String fDate =
                                      DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(dateTime);
                                  setState(() {
                                    startDate = fDate;
                                    // dtime = dateTime;
                                    _startDateController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _endDateController,
                              decoration: const InputDecoration(
                                prefixIconColor: Colors.white,
                                fillColor: primary,
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                labelText: 'End date',
                                filled: true,
                                prefixIcon: Icon(Icons.calendar_today),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? dateTime =
                                    await showOmniDateTimePicker(
                                  context: context,
                                  firstDate: dtime,
                                  is24HourMode: false,
                                  isShowSeconds: false,
                                  minutesInterval: 5,
                                  secondsInterval: 60,
                                );
                                // debugPrint('dateTime: $dateTime');

                                if (dateTime != null) {
                                  String formattedDate = DateFormat('y-M-d')
                                      .add_jm()
                                      .format(dateTime);
                                  String fDate =
                                      DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(dateTime);
                                  setState(() {
                                    endDate = fDate;
                                    _endDateController.text = formattedDate;
                                  });
                                }
                              },
                            ),

                            // ElevatedButton(
                            //   onPressed: () async {
                            //     final DateTime? dateTime =
                            //         await showOmniDateTimePicker(
                            //       context: context,
                            //       firstDate: DateTime.now(),
                            //       is24HourMode: false,
                            //       isShowSeconds: false,
                            //       minutesInterval: 5,
                            //       secondsInterval: 60,
                            //     );

                            //     // Use dateTime here
                            //     debugPrint('dateTime: $dateTime');
                            //   },
                            //   child: const Text('Show DateTime Picker'),
                            // ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     final List<DateTime>? dateTime =
                            //         await showOmniDateTimeRangePicker(
                            //             context: context);

                            //     // Use dateTime here
                            //     debugPrint('dateTime: $dateTime');
                            //   },
                            //   child: const Text('Show DateTime Picker'),
                            // ),
                          ],
                        ),
                      ],
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
                              // print(startDate);
                              // print(endDate);
                              // print(userId);
                              const storage = FlutterSecureStorage();
                              final token = await storage.read(key: 'auth');

                              try {
                                // print('USAO U TRY');
                                di.Response res = await dio().post('create-bid',
                                    data: {
                                      'startDate': startDate,
                                      'endDate': endDate,
                                      'userId': userId,
                                    },
                                    options: di.Options(headers: {
                                      'Authorization': 'Bearer $token',
                                    }));
                                // print(res.statusCode.toString());
                                // print(res.toString());
                                if (res.data['status'] == 'ok') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackBar(context,
                                          'Successfully created', false));

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const Ownerbidlist())));
                                }
                              } on di.DioException catch (e) {
                                if (e.response?.statusCode == 422) {
                                  _validationErrorCreateBid =
                                      ValidationErrorCreateBid.fromJson(
                                          e.response!.data['errors']);
                                }
                              }
                            },
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all<double>(0.0),
                              backgroundColor: WidgetStateProperty.all<Color>(
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
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: const Text(
                                'CREATE',
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
      ],
    );
  }
}
