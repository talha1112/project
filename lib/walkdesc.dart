import 'package:flutter/material.dart';
import 'package:test/global/colors.dart';

class Walkdesc extends StatefulWidget {
  const Walkdesc({super.key});

  @override
  _WalkdescState createState() => _WalkdescState();
}

class _WalkdescState extends State<Walkdesc> {
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
                          'Lilly',
                          style:
                              TextStyle(color: Color(0xff2a636d), fontSize: 30),
                        ),
                        Text(
                          'Profile of the owner',
                          style:
                              TextStyle(color: Color(0xff2a636d), fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/dog-profile.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Purebred',
                              style: TextStyle(
                                  color: Color(0xff2a636d), fontSize: 20),
                            ),
                            Text(
                              '6 months / ',
                              style: TextStyle(
                                  color: Color(0xff2a636d), fontSize: 15),
                            ),
                            Text(
                              'Chicago',
                              style: TextStyle(
                                  color: Color(0xff2a636d), fontSize: 18),
                            ),
                            // SizedBox(
                            //   height: 10,
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'About Lilly:',
                                      style: TextStyle(
                                          color: Color(0xff2a636d),
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'A mischievous and cheerful shepherd wholoves long walks in the parks. It is possible to pick up the dog at our address.We will wait your message!',
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xff2a636d),
                                        fontSize: 12,
                                      ),
                                      maxLines: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Chicago / 8 - 10am',
                                      style: TextStyle(
                                          color: primary, fontSize: 16),
                                    ),
                                    Text(
                                      '6\$/h',
                                      style: TextStyle(
                                          color: primary,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
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
                                'SEND AN OFFER',
                                style: Theme.of(context).textTheme.labelLarge,
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
