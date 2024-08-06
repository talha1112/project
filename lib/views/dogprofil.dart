import 'dart:convert';
import '../models/dog.dart';
import '../global/conf.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/global/colors.dart';
import '../helper/dog_age_calculator.dart';
import 'package:test/views/dogprofil_edit.dart';
import 'package:test/views/ownercreatewalk.dart';

class Dogprofil extends StatefulWidget {
  const Dogprofil({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DogprofilState createState() => _DogprofilState();
}

class _DogprofilState extends State<Dogprofil> {
  Dog? dog;
  bool isLoading = true;

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
  bool isOwner = false;
  bool isWalker = false;

  // late Core core;

  // Future<void> getUserFirstName() async {
  //   try {
  //     User? usr = Provider.of<Auth>(context, listen: false).user;
  //     isOwner = Provider.of<Auth>(context, listen: false).isOwner;
  //     isWalker = Provider.of<Auth>(context, listen: false).isWalker;
  //     setState(() {
  //       userFirstName = usr!.name!;
  //     });
  //   } catch (e) {
  //     print('error :$e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getUserFirstName();
    fetchDogData();
  }

  Future<void> fetchDogData() async {
    Future token = Provider.of<Auth>(context, listen: false).getToken();

    final response = await http.post(Uri.parse("$API_URL/get-dog"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });

    // print('response.statusCode');
    // print(response.statusCode);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        dog = Dog.fromJson(data['dog']);
        // print(data['dog']['image']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load dog data');
    }
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
                                'Dog profil',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          ),
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
                                dog?.name ?? 'N/A',
                                style: const TextStyle(
                                    color: Color(0xff2a636d), fontSize: 30),
                              ),
                              // Text(
                              //   'Profile of the owner',
                              //   style:
                              //       TextStyle(color: Color(0xff2a636d), fontSize: 12),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  dog?.image ??
                                      'https://dog.willtaxi.wien/img/noimage.jpg',
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
                                        dog?.breed?.name != null
                                            ? ((dog!.breed!.name!.length > 10)
                                                ? '${dog?.breed?.name!.substring(0, 10)}...'
                                                : dog?.breed?.name)!
                                            : '',
                                        style: const TextStyle(
                                            color: Color(0xff2a636d),
                                            fontSize: 20),
                                      ),
                                      // Text(
                                      //   dog?.breed?.name ?? 'N/A',
                                      //   style: const TextStyle(
                                      //       color: Color(0xff2a636d),
                                      //       fontSize: 20),
                                      // ),
                                      Text(
                                        '${DogAgeCalculator.calculateAge(dog?.birthday ?? '')} / ${dog?.weight ?? ''} lb',
                                        style: const TextStyle(
                                            color: Color(0xff2a636d),
                                            fontSize: 12),
                                      ),
                                      Text(
                                        dog?.city ?? 'N/A',
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
                                            'ZIP: ${dog?.zip ?? 'N/A'}',
                                            style: const TextStyle(
                                                color: primary, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Average score: 4.8',
                                        style: TextStyle(
                                            color: Color(0xff2a636d),
                                            fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/medalja.png',
                                            width: 60,
                                          ),
                                          const Text(
                                            'Super owner!',
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
                          //               'assets/kisobran.png',
                          //               height: 40,
                          //             ),
                          //             const SizedBox(
                          //               width: 10,
                          //             ),
                          //             Image.asset(
                          //               'assets/cvece.png',
                          //               height: 40,
                          //             ),
                          //             const SizedBox(
                          //               width: 10,
                          //             ),
                          //             Image.asset(
                          //               'assets/lopta.png',
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
                                              const Dogprofiledit()),
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
                                      'EDIT DOG',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                              const Ownercreatebid()),
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
                                      'CREATE WALK',
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
