import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../models/zip.dart';
import '../global/conf.dart';
import '../models/city.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/models/owner.dart';
import 'package:test/global/colors.dart';
import 'package:test/views/ownerprofil.dart';
import 'package:test/widgets/navdrawer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Ownerprofiledit extends StatefulWidget {
  const Ownerprofiledit({super.key});

  @override
  _OwnerprofileditState createState() => _OwnerprofileditState();
}

class _OwnerprofileditState extends State<Ownerprofiledit> {
  // Color getColor(Set<WidgetState> states) {
  //   const Set<WidgetState> interactiveStates = <WidgetState>{
  //     WidgetState.pressed,
  //     WidgetState.hovered,
  //     WidgetState.focused,
  //   };
  //   if (states.any(interactiveStates.contains)) {
  //     return Colors.blue;
  //   }
  //   return const Color(0xfffa8d62);
  // }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _housenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutmeController = TextEditingController();

  bool _saveProgres = false;
  bool _validateName = false;
  String _validateNameText = '';

  final bool _validateAboutme = false;
  final String _validateAboutmeText = '';
  bool _validatePhone = false;
  String _validatePhoneText = '';
  bool _validateStreet = false;
  String _validateStreetText = '';
  bool _validateHousenumber = false;
  String _validateHousenumberText = '';
  bool _validateEmail = false;
  bool _validateEmailInvalid = false;
  String _validateEmailText = '';

  Owner? owner;

  List<City> cities = [];
  List<Zip> zips = [];
  City? selectedCity;
  Zip? selectedZip;

  bool isLoading = true;

  bool isChecked = false;
  late Future token;
  @override
  void initState() {
    super.initState();
    token = Provider.of<Auth>(context, listen: false).getToken();

    fetchOwnerprofileditData();
  }

  Future<void> fetchOwnerprofileditData() async {
    final response = await http
        .post(Uri.parse("$API_URL/get-myprofil-owner-edit"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });

    // print(await token);
    // print('response.statusCode');
    // print(response.statusCode);
    // print(response);
    // print(response.toString());
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // print(json.decode(response.body)['selected_zip']);

      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> dataCities = data['cities'];
      final List<dynamic> dataZips = data['zips'];
      setState(() {
        cities = dataCities.map((json) => City.fromJson(json)).toList();
        zips = dataZips.map((json) => Zip.fromJson(json)).toList();
        selectedCity = cities.first;
        // selectedZip = zips.first;
        // selectedZip = json.decode(response.body)['selected_zip'];

        owner = Owner.fromJson(data['owner']);
        _nameController.text = owner!.name!;
        _emailController.text = owner!.email!;
        _phoneController.text = owner!.phone!;

        selectedCity = cities.firstWhere(
            (city) => city.id.toString() == owner!.city_id!,
            orElse: () => cities.first);

        selectedZip = zips.firstWhere(
            (zip) => zip.id.toString() == owner!.zip_id!,
            orElse: () => zips.first);

        _streetController.text = owner!.street!;
        _housenumberController.text = owner!.house_number!;
        _aboutmeController.text = owner!.about_me!;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  File? imageFile;

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
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

    _validatePhone = _phoneController.text.isEmpty;

    if (_validatePhone) {
      setState(() {
        _validatePhoneText = "Phone can't be empty";
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

    if (validated) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      drawer: const NavDrawer(),
      backgroundColor: const Color(0xffd6e9e8),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
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
                              'OWNER PROFIL',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
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
            isLoading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 30),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: const Text(
                              'EDIT',
                              style: TextStyle(
                                  color: Color(0xff2a636d), fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: GestureDetector(
                          onTap: () async {
                            await selectFile();
                          },
                          child: Container(
                            child: (imageFile == null)
                                ? Image.network(
                                    (owner?.profile_image != null &&
                                            owner!.profile_image != '')
                                        ? owner!.profile_image!
                                        : 'https://dog.willtaxi.wien/img/noimage.jpg',
                                    height: 200,
                                  )
                                : Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                    errorText: _validateName
                                        ? _validateNameText
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 35),
                            child: const Text(
                              'Phone',
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
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneController,
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      decorationThickness: 0,
                                      color: Colors.white,
                                      fontSize: 16),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    errorText: _validatePhone
                                        ? _validatePhoneText
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
                                  readOnly: true,
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    errorText: (_validateEmail ||
                                            _validateEmailInvalid)
                                        ? _validateEmailText
                                        : null,
                                    errorStyle:
                                        const TextStyle(color: Colors.red),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 35),
                            child: const Text(
                              'About me:',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Lemon'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: const Color(0xffaee0d5),
                                  ),
                                  width: 340,
                                  child: TextField(
                                    controller: _aboutmeController,
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    maxLines: 4, //or null
                                    decoration: InputDecoration(
                                      errorText: (_validateAboutme)
                                          ? _validateAboutmeText
                                          : null,
                                      errorStyle:
                                          const TextStyle(color: Colors.red),
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
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 30),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: const Text(
                              'Location',
                              style: TextStyle(
                                  color: Color(0xff2a636d), fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'City:',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Lemon'),
                          ),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: 340,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          items: cities
                                              .map<DropdownMenuItem<City>>(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xffaee0d5),
                                            ),
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              // radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
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
                      SizedBox(
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
                                items:
                                    zips.map<DropdownMenuItem<Zip>>((Zip zip) {
                                  return DropdownMenuItem<Zip>(
                                    value: zip,
                                    child: Text(
                                      '${selectedCity!.name} - ${zip.code!}',
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
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 270,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (validateForm()) {
                                  setState(() {
                                    _saveProgres = true;
                                  });
                                  try {
                                    Future token = Provider.of<Auth>(context,
                                            listen: false)
                                        .getToken();

                                    var request = http.MultipartRequest(
                                      'POST',
                                      Uri.parse(
                                          "$API_URL/get-myprofil-owner-update"),
                                    );

                                    // Dodavanje ostalih polja u request
                                    request.fields['name'] =
                                        _nameController.text;
                                    request.fields['email'] =
                                        _emailController.text;
                                    request.fields['phone'] =
                                        _phoneController.text;
                                    request.fields['about_me'] =
                                        _aboutmeController.text;
                                    request.fields['city_id'] =
                                        selectedCity!.id.toString();
                                    request.fields['zip_id'] =
                                        selectedZip!.id.toString();
                                    request.fields['street'] =
                                        _streetController.text;
                                    request.fields['house_number'] =
                                        _housenumberController.text;

                                    // Dodavanje slike u request ako postoji
                                    if (imageFile != null) {
                                      request.files.add(
                                        await http.MultipartFile.fromPath(
                                          'profile_image',
                                          imageFile!.path,
                                          contentType: MediaType('image',
                                              'jpeg'), // Postavite odgovarajući content type
                                        ),
                                      );
                                    }

                                    // Dodavanje headera u request
                                    request.headers['Accept'] =
                                        'application/json';
                                    request.headers['Authorization'] =
                                        'Bearer ${await token}';
                                    // Slanje request-a
                                    var response = await request.send();
                                    // print('response.statusCode');
                                    // print(response.statusCode);
                                    // print(await response.stream.bytesToString());
                                    // Obrada odgovora
                                    if (response.statusCode == 200) {
                                      // final responseBody =
                                      //     await response.stream.bytesToString();
                                      // final Map<String, dynamic> data =
                                      //     json.decode(responseBody);
                                      // print(data);
                                      // setState(() {
                                      //   _saveProgres = false;
                                      // });
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                const Ownerprofil()),
                                      );
                                    } else {
                                      setState(() {
                                        _saveProgres = false;
                                      });
                                      throw Exception('Failed to load data');
                                    }
                                  } catch (e) {
                                    print('Error: $e');
                                  }
                                } else {
                                  // print('ERRORRRR');
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: (_saveProgres)
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'UPDATE',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 300,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
