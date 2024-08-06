import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/views/ownerprofil.dart';
import 'package:test/views/walkerprofil.dart';

import '../providers/auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/custom_textformfiled.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isOwner = false;
  bool isWalker = false;

  @override
  void initState() {
    super.initState();
    // _email.text = 'adamo.vic.boban@gmail.com';
    // _password.text = '123123123';

    // _email.text = 'pedja.1982@gmail.com';
    _email.text = 'pedja1982@gmail.com';
    _password.text = '123123123';
    setState(() {
      isOwner = Provider.of<Auth>(context, listen: false).isOwner;
      isWalker = Provider.of<Auth>(context, listen: false).isWalker;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      var result = await Provider.of<Auth>(context, listen: false).login(
          credential: {'email': _email.text, 'password': _password.text});

      if (result['error']) {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, result['message'], true));
        return false;
      }

      isOwner = Provider.of<Auth>(context, listen: false).isOwner;
      isWalker = Provider.of<Auth>(context, listen: false).isWalker;

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(customSnackBar(context, result['message'], false));

      // print('isWalker');
      // print(isWalker);
      if (isWalker) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const Walkerprofil())));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const Ownerprofil())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, 'faild to login ', true));
    }
  }

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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
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
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // if (_email.text == 'owner@waggywalking.com') {
                        if (_email.text == 'adamo.vic.boban@gmail.com') {
                          _email.text = 'pedja.1982@gmail.com';
                        } else {
                          _email.text = 'owner@waggywalking.com';
                        }
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
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: const Text(
                          'toggle',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                email: _email,
                                label: 'Email',
                                hint: 'example@gmail.com',
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomTextFormField(
                                  email: _password,
                                  hint: 'Enter Your Password',
                                  label: 'Password'),
                              CustomButton(onTap: submit, title: 'Login')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 270,
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ButtonStyle(
                //           elevation: WidgetStateProperty.all<double>(0.0),
                //           backgroundColor: WidgetStateProperty.all<Color>(
                //               const Color(0xFFf67943)),
                //           shape:
                //               WidgetStateProperty.all<RoundedRectangleBorder>(
                //             RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.circular(5.0), // radius you want
                //               side: const BorderSide(
                //                 color: Color(0xFFf67943), //color
                //               ),
                //             ),
                //           ),
                //         ),
                //         child: Container(
                //           padding: const EdgeInsets.only(top: 5, bottom: 5),
                //           child: Text(
                //             'WALKER',
                //             style: Theme.of(context).textTheme.headlineLarge,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('or sign in with'),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
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
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Become a walker!'),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5.0), // radius you want
                              side: const BorderSide(
                                color: Color(0xFF2d6270), //color
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Sign up!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
