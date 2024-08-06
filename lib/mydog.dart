import 'package:flutter/material.dart';
import 'package:test/views/terms.dart';
import 'package:test/global/colors.dart';

class Mydog extends StatefulWidget {
  const Mydog({super.key});

  @override
  _MydogState createState() => _MydogState();
}

class _MydogState extends State<Mydog> {
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
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/user-profile.png',
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
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
                      height: 100,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'My dog',
                            style: TextStyle(
                                color: Color(0xff2a636d), fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Text(
                        'Name of my dog',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                  start: 20.0,
                                ),
                                fillColor: const Color(0xffaee0d5),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                // labelText: 'E-Mail',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Text(
                        'Breed of dog',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                  start: 20.0,
                                ),
                                fillColor: const Color(0xffaee0d5),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                // labelText: 'E-Mail',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Text(
                        'My place',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                  start: 20.0,
                                ),
                                fillColor: const Color(0xffaee0d5),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                // labelText: 'E-Mail',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Text(
                        'My average earnings',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                  start: 20.0,
                                ),
                                fillColor: const Color(0xffaee0d5),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                // labelText: 'E-Mail',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                                width: 2.0, color: Color(0xffcb5d38)),
                          ),
                          checkColor: Colors.white,
                          // fillColor: WidgetStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        InkWell(
                          onTap: (() {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          }),
                          child: const Text('I understnd the '),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const Terms()),
                            );
                          },
                          child: const Text(
                            'terms & policy',
                            style: TextStyle(color: Color(0xffcb5d38)),
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
                                'UPDATE',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
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
