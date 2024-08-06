import 'package:flutter/material.dart';
import 'package:test/views/login.dart';
import 'package:test/views/register.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background-login.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/logo.jpg',
                      height: 180,
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOG IN',
                    style: TextStyle(
                        fontFamily: 'Lemon', color: Colors.white, fontSize: 25),
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
                              pageBuilder: (_, __, ___) => const Login()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFca5e38)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.0), // radius you want
                            side: const BorderSide(
                              color: Color(0xFFca5e38), //color
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: const Text(
                          'WALKER',
                          style: TextStyle(color: Colors.white, fontSize: 30),
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
                    width: 270.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF2d6270)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.0), // radius you want
                            side: const BorderSide(
                              color: Color(0xFF2d6270), //color
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: const Text(
                          'DOG OWNER',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('or sign in with',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    // width: 70.0,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFFFFFFF)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.0), // radius you want
                            side: const BorderSide(
                              color: Color(0xFFFFFFFF), //color
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Image.asset(
                          'assets/google.png',
                          // height: 50,
                          // width: 70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Become a walker!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180.0,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Register()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF2d6270)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.0), // radius you want
                            side: const BorderSide(
                              color: Color(0xFF2d6270), //color
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        // padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: const Text(
                          'Sign up!',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
