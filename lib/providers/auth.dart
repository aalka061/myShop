import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

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
      // Update user interface to trigger consutmer (Material app)
      notifyListeners();
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
}
