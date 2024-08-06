import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../global/conf.dart';
import '../helper/dio.dart';
import '../models/error.dart';
import '../models/user.dart';

// import 'package:platform_device_id/platform_device_id.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;
  bool _isOwner = false;
  bool _isWalker = false;
  User? _user;
  ValidationError? _validationError;
  ValidationError? get validationError => _validationError;
  User? get user => _user;
  final storage = const FlutterSecureStorage();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  bool get authenticated => _authenticated;
  bool get isOwner => _isOwner;
  bool get isWalker => _isWalker;
  bool _obscureText = false;

  bool get obscureText => _obscureText;

  Future register({credential}) async {
    String deviceId = await getDeviceId();
    try {
      Response res = await dio().post('register',
          data: json.encode(credential..addAll({'deviceId': deviceId})));
      String token = await res.data['token'];
      await attempt(token);
      await storeToken(token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        _validationError = ValidationError.fromJson(e.response!.data['errors']);
        notifyListeners();
      }
    }
  }

  Future login({required Map credential}) async {
    String deviceId = await getDeviceId();
    // try {
    // Response response = await dio().post('login',
    //     data: json.encode(credential..addAll({'deviceId': deviceId})));

    final response = await http.post(Uri.parse('$API_URL/login'), body: {
      'email': credential['email'],
      'password': credential['password'],
      'device_name': deviceId,
    }, headers: {
      'Accept': 'application/json',
    });

    // print('MMMMMMMMMMMMMMMMMMMMMMMMM');
    // debugPrint(response.statusCode.toString());
    if (response.statusCode == 429) {
      return {
        'success': false,
        'message': 'Previše pokušaja, molimo vas pokušajte kasnije.'
      };
    }
    if (response.statusCode == 401) {
      var data = json.decode(response.body);
      return data;
    }
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // if (!data['error']) {
      //   return data;
      // }
      // print(data['access_token']);
      String token = await data['access_token'];
      String role = await data['role'];
      // print('XXXXXXXXXXXXXXXX');
      // print(role);
      if (role == 'owner') {
        _isOwner = true;
      }
      if (role == 'walker') {
        _isWalker = true;
      }
      await attempt(token);
      await storeToken(token);
      await storeRole(role);
      return data;
    }

    // var data = response.data;
    // Map data = response.data;
    // if (data['error']) {
    //   return data;
    // }
    // print('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
    // print(data);

    // if (response.data['role'] != 'owner' &&
    //     response.data['role'] != 'walker') {
    //   _authenticated = false;
    //   return false;
    // }

    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 422) {
    //     _validationError = ValidationError.fromJson(e.response!.data['errors']);
    //     notifyListeners();
    //   }
    // }
  }

  Future attempt(String? token) async {
    if (token == null || token == '' || token.isEmpty) {
      return;
    }
    // try {
    final response = await http.get(Uri.parse('$API_URL/user'), headers: {
      'Authorization': 'Bearer $token',
    });

    print('BBBBBBBBBBBBBBBBBBBBB');
    print(response.statusCode);
    print(token);
    print('BBBBBBBBBBBBBBBBBBBBB');

    final Map<String, dynamic> data = json.decode(response.body);
    _user = User.fromJson(data);

    _user = User.fromJson(data);
    if (_user?.role == 'owner') {
      _isOwner = true;
    }
    if (_user?.role == 'walker') {
      _isWalker = true;
    }

    if (_user?.id != null) {
      _authenticated = true;
    } else {
      _authenticated = false;
    }
    // } catch (e) {
    //   _authenticated = false;
    //   log('error log ${e.toString()}');
    // }
    notifyListeners();
  }

  Future getDeviceId() async {
    final mobileDeviceIdentifierPlugin = MobileDeviceIdentifier();
    // String? deviceId = await PlatformDeviceId.getDeviceId;
    String? deviceId = await mobileDeviceIdentifierPlugin.getDeviceId() ??
        'Unknown platform version';
    return deviceId;
  }

  Future storeToken(String token) async {
    await storage.write(key: 'auth', value: token);
  }

  Future storeRole(String role) async {
    await storage.write(key: 'role', value: role);
  }

  static Future<String?> getStaticToken() async {
    return await _storage.read(key: 'auth');
  }

  Future getToken() async {
    final token = await storage.read(key: 'auth');
    return token;
  }

  Future getRole() async {
    final role = await storage.read(key: 'role');
    return role;
  }

  Future deleteToken() async {
    await storage.delete(key: 'auth');
  }

  Future deleteRole() async {
    await storage.delete(key: 'role');
  }

  Future logout() async {
    final token = await storage.read(key: 'auth');
    _authenticated = false;
    await dio().post('logout',
        data: {'deviceId': await getDeviceId()},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    await deleteToken();
    await deleteRole();
    _isOwner = false;
    _isWalker = false;

    notifyListeners();
  }

  void toggleText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
