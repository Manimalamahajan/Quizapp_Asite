import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class InterestedStream with ChangeNotifier{
  final String token;
  InterestedStream(this.token);
  List _interestedStreamsList = [];

  List get interestedStreamsList {
    return _interestedStreamsList;
  }

  Future<void> fetchInterestedStreams() async {
    try {
      final response = await  NetworkCall().getRequest('user/getInterestedStream',
          {"Authorization": "Bearer $token",'Content-Type':'application/json'});
      _interestedStreamsList = response;
      print(_interestedStreamsList);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
