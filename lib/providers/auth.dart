import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String userId;

  final apiKey = "AIzaSyCSXFAvbFqvHddFk4vI6C2KnDmtAqRXaAM";

  Future<void> signup(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey";
    print(email);
    print(password);
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    print(json.decode(response.body));
  }
}
