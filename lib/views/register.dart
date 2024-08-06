import 'dart:convert';
import '../global/conf.dart';
import '../models/city.dart';
import '../models/breed.dart';
import 'package:intl/intl.dart';
import 'package:test/models/zip.dart';
import 'package:flutter/material.dart';
import 'package:test/views/login.dart';
import 'package:test/views/terms.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _validateName = false;
  String _validateNameText = '';
  bool _validateStreet = false;
  String _validateStreetText = '';
  bool _validateHousenumber = false;
  String _validateHousenumberText = '';
  bool _validateEmail = false;
  bool _validateEmailInvalid = false;
  String _validateEmailText = '';
  bool _validatePassword = false;
  bool _validatePasswordCount = false;
  String _validatePasswordText = '';

  bool _validatePasswordConfirm = false;
  bool _validatePasswordConfirmCount = false;
  bool _validatePasswordConfirmSame = false;
  String _validatePasswordConfirmText = '';

  bool _validateDogName = false;
  String _validateDogNameText = '';

  bool _validateDogBirthday = false;
  String _validateDogBirthdayText = '';

  bool _validateDogWeight = false;
  String _validateDogWeightText = '';
  bool _validateTerms = false;
  String _validateTermsText = '';

  final TextEditingController _dogBirthdayController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _housenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dogNameController = TextEditingController();
  final TextEditingController _dogWeightController = TextEditingController();
  DateTime dtime = DateTime.now();
  late String birthDate = '';

  List<Breed> breeds = [];
  List<City> cities = [];
  List<Zip> zips = [];
  Breed? selectedBreed;
  City? selectedCity;
  Zip? selectedZip;
  bool isLoading = true;

  bool _obscureText = true;
  String choice = '';
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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

  bool isCheckedTerms = false;

  @override
  void initState() {
    super.initState();
    fetchBreeds();
    _nameController.text = 'Neko ime';
    _streetController.text = 'Neka ulica';
    _housenumberController.text = '77';
    _emailController.text = 'adamo.vic.boban@gmail.com';
    _passwordController.text = '123123123';
    _confirmPasswordController.text = '123123123';
    _dogNameController.text = 'DZEKI';
    _dogBirthdayController.text = '2024-05-12';
    _dogWeightController.text = '77';
  }

  Future<void> fetchBreeds() async {
    final response =
        await http.post(Uri.parse("$API_URL/get-breeds"), headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> dataBreeds = json.decode(response.body)['breeds'];
      final List<dynamic> dataCities = json.decode(response.body)['cities'];
      final List<dynamic> dataZips = json.decode(response.body)['zips'];
      setState(() {
        breeds = dataBreeds.map((json) => Breed.fromJson(json)).toList();
        cities = dataCities.map((json) => City.fromJson(json)).toList();
        zips = dataZips.map((json) => Zip.fromJson(json)).toList();
        selectedBreed = breeds.first;
        selectedCity = cities.first;
        selectedZip = zips.first;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  bool validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!(regex.hasMatch(email))) {
      // print('TRUE');
      return true;
    }
    // print('FALSE');

    return false;
  }

  bool validateForm() {
    bool validated = true;
    _validateName = _nameController.text.isEmpty;

    if (_validateName) {
      setState(() {
        _validateNameText = "Name can't be empty";
      });
      validated = false;
    }

    _validateEmail = _emailController.text.isEmpty;

    if (_validateEmail) {
      setState(() {
        _validateEmailText = "E-Mail can't be empty";
      });
      validated = false;
    }
    _validateEmailInvalid = validateEmail(_emailController.text);

    if (_validateEmailInvalid) {
      setState(() {
        _validateEmailText = "Invalid email address";
      });
      validated = false;
    }

    _validatePassword = _passwordController.text.isEmpty;

    if (_validatePassword) {
      setState(() {
        _validatePasswordText = "Password can't be empty";
      });
      validated = false;
    }
    _validatePasswordCount = _passwordController.text.length < 8;

    if (_validatePasswordCount) {
      setState(() {
        _validatePasswordText =
            "The password must contain at least 8 characters.";
      });
      validated = false;
    }

    _validatePasswordConfirm = _confirmPasswordController.text.isEmpty;

    if (_validatePasswordConfirm) {
      setState(() {
        _validatePasswordConfirmText = "Confirm password can't be empty";
      });
      validated = false;
    }
    _validatePasswordConfirmCount = _confirmPasswordController.text.length < 8;

    if (_validatePasswordConfirmCount) {
      setState(() {
        _validatePasswordConfirmText =
            "The confirm password must contain at least 8 characters.";
      });
      validated = false;
    }

    _validatePasswordConfirmSame =
        _passwordController.text != _confirmPasswordController.text;

    if (_validatePasswordConfirmSame) {
      setState(() {
        _validatePasswordConfirmText =
            "Password and confirm password must be the same.";
      });
      validated = false;
    }

    _validateStreet = _streetController.text.isEmpty;

    if (_validateStreet) {
      setState(() {
        _validateStreetText = "Street can't be empty";
      });
      validated = false;
    }

    _validateHousenumber = _housenumberController.text.isEmpty;

    if (_validateHousenumber) {
      setState(() {
        _validateHousenumberText = "House number can't be empty";
      });
      validated = false;
    }

    if (choice == 'owner') {
      _validateDogName = _dogNameController.text.isEmpty;

      if (_validateDogName) {
        setState(() {
          _validateDogNameText = "Dog name can't be empty";
        });
        validated = false;
      }
      _validateDogBirthday = _dogBirthdayController.text.isEmpty;

      if (_validateDogBirthday) {
        setState(() {
          _validateDogBirthdayText = "Dog birthday can't be empty";
        });
        validated = false;
      }
      _validateDogWeight = _dogWeightController.text.isEmpty;

      if (_validateDogWeight) {
        setState(() {
          _validateDogWeightText = "Dog weight can't be empty";
        });
        validated = false;
      }
    }
    _validateTerms = !isCheckedTerms;
    if (_validateTerms) {
      setState(() {
        _validateTermsText =
            "You need to accept the Terms and Privacy Policy before proceeding.";
      });
      validated = false;
    }

    if (validated) {
      return true;
    } else {
      return false;
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
          resizeToAvoidBottomInset: true,
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create your account',
                      style: TextStyle(
                          fontFamily: 'Lemon',
                          color: Colors.white,
                          fontSize: 24),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            showCheckmark: false,
                            avatar: choice == 'walker'
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : const Text(''),
                            label: const Text('I am a dog walker',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            selected: choice == 'walker',
                            onSelected: (bool selected) {
                              // print('selected111');
                              // print(selected);
                              // print(choice);
                              setState(() {
                                choice = 'walker';
                                // choice = (selected ? 'walker' : null)!;
                              });

                              // print('selected');
                              // print(selected);
                              // print(choice);
                            },
                            selectedColor: const Color(0xFFf67943),
                            backgroundColor: const Color(0xFFf67943),
                            elevation: 5.0,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                width: 0,
                                color: Color(0xFFf67943),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ChoiceChip(
                            // avatar: image.asset("assets/right.png",
                            //     matchTextDirection: false, width: 20.0),
                            showCheckmark: false,
                            avatar: choice == 'owner'
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : const Text(''),
                            label: const Text(
                              'I am a dog owner',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            selected: choice == 'owner',
                            onSelected: (bool selected) {
                              setState(() {
                                choice = 'owner';
                                // choice = (selected ? 'owner' : null)!;
                              });
                            },
                            selectedColor: const Color(0xFFf67943),
                            backgroundColor: const Color(0xFFf67943),
                            elevation: 5.0,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                width: 0,
                                color: Color(0xFFf67943),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                if (choice != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Name',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lemon'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  decorationThickness: 0,
                                  color: Colors.white,
                                  fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText:
                                    _validateName ? _validateNameText : null,
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                ),

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
                                // labelText: 'type your name',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (choice != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'E-Mail:',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lemon'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              // onTap: () {
                              //   setState(() {
                              //     _validateEmail = _validateEmailInvalid = false;
                              //   });
                              // },
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText:
                                    (_validateEmail || _validateEmailInvalid)
                                        ? _validateEmailText
                                        : null,
                                errorStyle: const TextStyle(color: Colors.red),
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
                        ],
                      ),
                    ],
                  ),
                if (choice != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Password:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: (_validatePassword ||
                                        _validatePasswordCount)
                                    ? _validatePasswordText
                                    : null,
                                errorStyle: const TextStyle(color: Colors.red),
                                errorMaxLines: 2,
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                  start: 20.0,
                                ),
                                suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: Icon(
                                    _obscureText
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
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
                        ],
                      ),
                    ],
                  ),
                if (choice != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Confirm Password:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureText,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: (_validatePasswordConfirm ||
                                        _validatePasswordConfirmCount ||
                                        _validatePasswordConfirmSame)
                                    ? _validatePasswordConfirmText
                                    : null,
                                errorStyle: const TextStyle(color: Colors.red),
                                errorMaxLines: 2,
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                  start: 20.0,
                                ),
                                suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: Icon(
                                    _obscureText
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
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
                        ],
                      ),
                    ],
                  ),
                if (choice != '')
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'City:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : choice != ''
                        ? SizedBox(
                            width: 340,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<City>(
                                    isExpanded: true,
                                    value: selectedCity,
                                    onChanged: (City? newValue) {
                                      setState(() {
                                        selectedCity = newValue!;
                                        // print(selectedCity!.id);
                                      });
                                    },
                                    items: cities.map<DropdownMenuItem<City>>(
                                        (City city) {
                                      return DropdownMenuItem<City>(
                                        value: city,
                                        child: Text(
                                          city.name!,
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(''),
                if (choice != '')
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Zip:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : choice != ''
                        ? SizedBox(
                            width: 340,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<Zip>(
                                    isExpanded: true,
                                    value: selectedZip,
                                    onChanged: (Zip? newValue) {
                                      setState(() {
                                        selectedZip = newValue!;
                                        // print(selectedZip!.id);
                                      });
                                    },
                                    items: zips
                                        .map<DropdownMenuItem<Zip>>((Zip zip) {
                                      return DropdownMenuItem<Zip>(
                                        value: zip,
                                        child: Text(
                                          '${selectedCity!.name} - ${zip.code!}',
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(''),
                if (choice != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Street',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lemon'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _streetController,
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  decorationThickness: 0,
                                  color: Colors.white,
                                  fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: _validateStreet
                                    ? _validateStreetText
                                    : null,
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                ),

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
                                // labelText: 'type your name',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (choice != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'House number',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lemon'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _housenumberController,
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  decorationThickness: 0,
                                  color: Colors.white,
                                  fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: _validateHousenumber
                                    ? _validateHousenumberText
                                    : null,
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                ),

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
                                // labelText: 'type your name',
                                // labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (choice == 'owner')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'My Dog',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Dog name:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _dogNameController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: (_validateDogName)
                                    ? _validateDogNameText
                                    : null,
                                errorStyle: const TextStyle(color: Colors.red),
                                errorMaxLines: 2,
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
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Dog birthday:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 340,
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _dogBirthdayController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                errorText: (_validateDogBirthday)
                                    ? _validateDogBirthdayText
                                    : null,
                                errorStyle: const TextStyle(color: Colors.red),
                                errorMaxLines: 2,
                                fillColor: const Color(0xffaee0d5),
                                prefixIconColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                // labelText: 'Birth date',
                                filled: true,
                                prefixIcon: const Icon(Icons.calendar_today),
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
                                  lastDate: DateTime.now(),
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
                                    birthDate = fDate;
                                    // dtime = dateTime;
                                    _dogBirthdayController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Dog weight: (lbs)',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: const Color(0xffaee0d5),
                            ),
                            width: 340,
                            child: TextField(
                              controller: _dogWeightController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: (_validateDogWeight)
                                    ? _validateDogWeightText
                                    : null,
                                errorStyle: const TextStyle(color: Colors.red),
                                errorMaxLines: 2,
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
                        ],
                      ),
                    ],
                  ),
                if (choice == 'owner')
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: const Text(
                          'Dog breed:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : choice == 'owner'
                        ? SizedBox(
                            width: 340,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<Breed>(
                                    isExpanded: true,
                                    value: selectedBreed,
                                    onChanged: (Breed? newValue) {
                                      setState(() {
                                        selectedBreed = newValue!;
                                        // print(selectedBreed!.id);
                                      });
                                    },
                                    items: breeds.map<DropdownMenuItem<Breed>>(
                                        (Breed breed) {
                                      return DropdownMenuItem<Breed>(
                                        value: breed,
                                        child: Text(
                                          breed.name!,
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(''),
                if (choice != '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        side: WidgetStateBorderSide.resolveWith(
                          (states) => const BorderSide(
                              width: 1.0, color: Color(0xffcb5d38)),
                        ),
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.resolveWith(getColor),
                        value: isCheckedTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedTerms = value!;
                          });
                        },
                      ),
                      InkWell(
                        onTap: (() {
                          setState(() {
                            isCheckedTerms = !isCheckedTerms;
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
                if (_validateTerms)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 270,
                        child: Text(
                          _validateTermsText,
                          style: const TextStyle(color: Colors.red),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                if (choice != '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 270,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (validateForm()) {
                              final response = await http
                                  .post(Uri.parse("$API_URL/register"), body: {
                                'name': _nameController.text,
                                'email': _emailController.text,
                                'password': _passwordController.text,
                                'city_id': selectedCity!.id.toString(),
                                'zip_id': selectedZip!.id.toString(),
                                'street': _streetController.text,
                                'house_number': _housenumberController.text,
                                'dog_name': _dogNameController.text,
                                'dog_birthday': _dogBirthdayController.text,
                                'dog_weight': _dogWeightController.text,
                                'dog_breed_id': selectedBreed!.id.toString(),
                                'choice': choice,
                              }, headers: {
                                'Accept': 'application/json',
                              });

                              // print('response.statusCode');
                              // print(response.statusCode);

                              if (response.statusCode == 200) {
                                final Map<String, dynamic> data =
                                    json.decode(response.body);
                                // print(data);
                              } else {
                                throw Exception('Failed to load data');
                              }
                            } else {
                              print('ERRORRRR');
                            }
                          },
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.all<double>(0.0),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xFFf67943)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
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
                              'REGISTER',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
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
                    Text('or sign in with',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Have an account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Login()),
                        );
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationThickness: 5.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
