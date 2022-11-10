import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class Update_Profile with ChangeNotifier{
  final String token;
  Update_Profile(this.token);
  Future<void> saveUserProfile(body) async {
    try {
      final response = await  NetworkCall().postRequest('user/profile/update',
        body,
        {"Authorization": "Bearer $token",'Content-Type':'application/json'},
      );

    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
