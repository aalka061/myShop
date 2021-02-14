import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String userId;

  final apiKey = "AIzaSyCSXFAvbFqvHddFk4vI6C2KnDmtAqRXaAM";

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
          },
        ),
      );
      print(res.body);
    } catch (e) {}
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
