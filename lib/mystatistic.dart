import 'package:flutter/material.dart';
import 'package:test/global/colors.dart';

class Mystatistic extends StatefulWidget {
  const Mystatistic({super.key});

  @override
  _MystatisticState createState() => _MystatisticState();
}

class _MystatisticState extends State<Mystatistic> {
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
          backgroundColor: const Color(0xffd6e9e8),
          resizeToAvoidBottomInset: false,
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
                                'Hello Nikola!',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text('My profile')],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text('My walks')],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text('My dog')],
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'My statistics',
                          style:
                              TextStyle(color: Color(0xff2a636d), fontSize: 30),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Booked walks:',
                                      style: TextStyle(
                                          color: Color(0xff2a636d),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '19',
                                      style: TextStyle(
                                          color: primary, fontSize: 30),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Earnings:',
                                      style: TextStyle(
                                          color: Color(0xff2a636d),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '140\$',
                                      style: TextStyle(
                                          color: primary, fontSize: 30),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Number of clients:',
                                      style: TextStyle(
                                          color: Color(0xff2a636d),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '13',
                                      style: TextStyle(
                                          color: primary, fontSize: 30),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Number of hours:',
                                      style: TextStyle(
                                          color: Color(0xff2a636d),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '14.5',
                                      style: TextStyle(
                                          color: primary, fontSize: 30),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Your place in your region:',
                                      style: TextStyle(
                                          color: Color(0xff2a636d),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '6',
                                      style: TextStyle(
                                          color: primary, fontSize: 30),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Average scode:',
                                  style: TextStyle(
                                      color: Color(0xff2a636d), fontSize: 22),
                                ),
                                Text(
                                  '9.2',
                                  style:
                                      TextStyle(color: primary, fontSize: 22),
                                ),
                              ],
                            ),
                          ),
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
                            onPressed: () {},
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
                              child: Text(
                                'FIND NEW CLIENTS',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Click here for ',
                              style: TextStyle(color: primary),
                            ),
                            Text(
                              'tips and ideas!',
                              style: TextStyle(
                                  color: primary,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
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
