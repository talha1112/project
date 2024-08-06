import 'dart:io';
import 'dart:convert';
import '../models/dog.dart';
import '../global/conf.dart';
import 'package:intl/intl.dart';
import '../providers/auth.dart';
import '../widgets/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test/models/breed.dart';
import 'package:test/global/colors.dart';
import 'package:test/views/dogprofil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Dogprofiledit extends StatefulWidget {
  const Dogprofiledit({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DogprofileditState createState() => _DogprofileditState();
}

class _DogprofileditState extends State<Dogprofiledit> {
  final TextEditingController _dogBirthdayController = TextEditingController();
  final TextEditingController _dogNameController = TextEditingController();
  final TextEditingController _dogWeightController = TextEditingController();
  final TextEditingController _dogDescriptionController =
      TextEditingController();

  bool _saveProgres = false;

  bool _validateDogName = false;
  String _validateDogNameText = '';

  bool _validateDogBirthday = false;
  String _validateDogBirthdayText = '';

  bool _validateDogWeight = false;
  String _validateDogWeightText = '';

  bool _validateDogDescription = false;
  String _validateDogDescriptionText = '';

  Breed? selectedBreed;
  Dog? dog;
  bool isLoading = true;
  late Future token;
  List<Breed> breeds = [];
  File? imageFile;
  late String birthDate = '';

  @override
  void initState() {
    super.initState();
    token = Provider.of<Auth>(context, listen: false).getToken();
    fetchDogeditData();
  }

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  Future<void> fetchDogeditData() async {
    final response =
        await http.post(Uri.parse("$API_URL/get-dog-edit"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    });

    if (response.statusCode == 200) {
      // print(json.decode(response.body)['selected_zip']);

      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> dataBreeds = data['breeds'];
      setState(() {
        breeds = dataBreeds.map((json) => Breed.fromJson(json)).toList();

        dog = Dog.fromJson(data['dog']);
        _dogNameController.text = dog!.name!;
        _dogWeightController.text = dog!.weight!;
        _dogBirthdayController.text = dog!.birthday!;
        _dogDescriptionController.text = dog!.description!;

        selectedBreed = breeds.firstWhere(
            (breed) => breed.id.toString() == dog!.breedId!.toString(),
            orElse: () => breeds.first);

        // _emailController.text = owner!.email!;
        // _phoneController.text = owner!.phone!;

        // selectedCity = cities.firstWhere(
        //     (city) => city.id.toString() == owner!.city_id!,
        //     orElse: () => cities.first);

        // selectedZip = zips.firstWhere(
        //     (zip) => zip.id.toString() == owner!.zip_id!,
        //     orElse: () => zips.first);

        // _streetController.text = owner!.street!;
        // _housenumberController.text = owner!.house_number!;
        // _aboutmeController.text = owner!.about_me!;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool validateForm() {
    bool validated = true;

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
    _validateDogDescription = _dogDescriptionController.text.isEmpty;

    if (_validateDogDescription) {
      setState(() {
        _validateDogDescriptionText = "Description can't be empty";
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
      backgroundColor: const Color(0xffd6e9e8),
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
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
                              'Dog profil',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'EDIT',
                              style: TextStyle(
                                  color: Color(0xff2a636d), fontSize: 30),
                            ),
                            // Text(
                            //   'Profile of the owner',
                            //   style:
                            //       TextStyle(color: Color(0xff2a636d), fontSize: 12),
                            // ),
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
                                      (dog?.image != null && dog?.image != '')
                                          ? dog!.image!
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
                        const Text(
                          'Dog name:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: const Color(0xffaee0d5),
                                ),
                                child: TextField(
                                  controller: _dogNameController,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    errorText: (_validateDogName)
                                        ? _validateDogNameText
                                        : null,
                                    errorStyle:
                                        const TextStyle(color: Colors.red),
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
                            ),
                          ],
                        ),
                        const Text(
                          'Dog birthday:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
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
                                  errorStyle:
                                      const TextStyle(color: Colors.red),
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
                                        DateFormat('yyyy-MM-dd')
                                            .format(dateTime);
                                    String fDate = DateFormat('yyyy-MM-dd')
                                        .format(dateTime);
                                    setState(() {
                                      birthDate = fDate;
                                      // dtime = dateTime;
                                      _dogBirthdayController.text =
                                          formattedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Dog weight: (lbs)',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: const Color(0xffaee0d5),
                                ),
                                child: TextField(
                                  controller: _dogWeightController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    errorText: (_validateDogWeight)
                                        ? _validateDogWeightText
                                        : null,
                                    errorStyle:
                                        const TextStyle(color: Colors.red),
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
                            ),
                          ],
                        ),
                        const Text(
                          'Dog breed:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
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
                                        items: breeds
                                            .map<DropdownMenuItem<Breed>>(
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xffaee0d5),
                                          ),
                                          offset: const Offset(0, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            // radius: const Radius.circular(40),
                                            thickness:
                                                WidgetStateProperty.all<double>(
                                                    6),
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
                        const Text(
                          'About dog:',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lemon'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: const Color(0xffaee0d5),
                                ),
                                width: 340,
                                child: TextField(
                                  controller: _dogDescriptionController,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  maxLines: 4, //or null
                                  decoration: InputDecoration(
                                    errorText: (_validateDogDescription)
                                        ? _validateDogDescriptionText
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
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
                                        Uri.parse("$API_URL/get-dog-update"),
                                      );

                                      // Dodavanje ostalih polja u request
                                      request.fields['name'] =
                                          _dogNameController.text;
                                      request.fields['birthday'] =
                                          _dogBirthdayController.text;
                                      request.fields['weight'] =
                                          _dogWeightController.text;
                                      request.fields['description'] =
                                          _dogDescriptionController.text;
                                      request.fields['breed_id'] =
                                          selectedBreed!.id.toString();
                                      // Dodavanje slike u request ako postoji
                                      if (imageFile != null) {
                                        request.files.add(
                                          await http.MultipartFile.fromPath(
                                            'image',
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
                                      // print(await response.stream
                                      // .bytesToString());
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
                                                  const Dogprofil()),
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
                                    print('ERRORRRR');
                                  }
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
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: (_saveProgres)
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'UPDATE',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
