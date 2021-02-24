import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  final apiKey = "AIzaSyCSXFAvbFqvHddFk4vI6C2KnDmtAqRXaAM";

  // True when authenticated
  // false when not authenticated
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _athunticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey';
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final resDecoded = json.decode(res.body);
      if (resDecoded['error'] != null) {
        throw HttpException(resDecoded['error']['message']);
      }
      // we we have not exception, we need to store the token, userId and expireDate
      _token = resDecoded['idToken'];
      _userId = resDecoded['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resDecoded['expiresIn'],
          ),
        ),
      );
      _autologout();
      // Update user interface to trigger consutmer (Material app)
      notifyListeners();

      // Start setting up our shared preferences
      // makeing sure you use async, await since shared preferences uses future
      final prefs = await SharedPreferences.getInstance();
      // serilized data (converted to json)
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      // store the string here so we can use it later
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    // we need to return the targeted action,  otherwise async (auto generated)
    // wont wait for autheticate action
    return _athunticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _athunticate(email, password, "signInWithPassword");
  }

  // use this function in the main file becuase it is where the app starts
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autologout();
    return true;
  }

  // clear all data
  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // clear the data from local storage
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autologout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
