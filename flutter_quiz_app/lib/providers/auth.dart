import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';


class Auth with ChangeNotifier {
  String? _token;


  bool get isAuth {
    return token != null;
  }

  String? get token {
      return _token;
  }
  Future<void> _authenticate(Map<String, String> authInfo, authType) async {
    if (authType == 'login') {
      final url = Uri.parse('http://192.168.102.92:8090/auth/user/login');
      try {
        final response = await http.post(
          url,
          body: json.encode(
            authInfo,
          ),
          headers: {'Content-Type':'application/json'},
        );
        final responseData = json.decode(response.body);
        // if (responseData['error'] != null) {
        //   throw HttpExceptions(responseData['error']['message']);
        // }
        _token = responseData["token"];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
          },
        );
        prefs.setString('userData', userData);
      } catch (error) {
        throw error;
      }
    } else if (authType == 'register') {
      final url = Uri.parse('http://192.168.102.92:8090/auth/user/signup');
      try {
        final response = await http.post(
          url,
          body: json.encode(authInfo),
          headers: {'Content-Type':'application/json'}
        );
        final responseData = json.decode(response.body);
        print(responseData);

      } catch (error) {
        throw error;
      }
    }
    notifyListeners();
  }

  Future<void> signup(Map<String, String> authData) async {
    return _authenticate(authData, 'register');
  }

  Future<void> login(Map<String, String> authData) async {
    return _authenticate(authData, 'login');
  }


  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
    json.decode(prefs.getString('userData')!);
    print(extractedUserData);
    _token = extractedUserData['token'];
    notifyListeners();
    return true;
  }


  Future<void> logout() async {
    _token = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
}
