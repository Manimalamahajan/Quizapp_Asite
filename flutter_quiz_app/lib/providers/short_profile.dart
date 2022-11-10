import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class ShortProfile with ChangeNotifier{
  final String token;
  ShortProfile(this.token);
  Map _shortProfile = {};

  Map get shortProfile {
    return _shortProfile;
  }

  Future<void> fetchShortProfile() async {
    try {
      final response = await  NetworkCall().getRequest('user/profile/short',
          {"Authorization": "Bearer $token",'Content-Type':'application/json'});
      _shortProfile = response;
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
