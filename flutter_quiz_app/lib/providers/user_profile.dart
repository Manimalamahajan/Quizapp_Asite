import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class UserProfile with ChangeNotifier{
  final String token;
  UserProfile(this.token);
  Map _userProfileList = {};

  Map get userProfileList {
    return _userProfileList;
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await  NetworkCall().getRequest('user/profile/full',
          {"Authorization": "Bearer $token",'Content-Type':'application/json'});
      _userProfileList = response;

    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
