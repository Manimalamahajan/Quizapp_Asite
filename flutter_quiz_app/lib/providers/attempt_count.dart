import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class AttemptCount with ChangeNotifier{
  final String token;
  AttemptCount(this.token);
  List _attemptList = [];

  List get attemptList {
    return _attemptList;
  }

  Future<void> fetchAttemptCount() async {
    try {
      final response = await  NetworkCall().getRequest('user/load/attempts',
          {"Authorization": "Bearer $token",'Content-Type':'application/json'});
      _attemptList = response;
      print(_attemptList);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
