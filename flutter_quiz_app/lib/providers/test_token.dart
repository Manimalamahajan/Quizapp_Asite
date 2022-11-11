import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class TestToken with ChangeNotifier{
  final String token;
  TestToken(this.token);
  Map _testtoken = {};

  Map get testtoken {
    return _testtoken;
  }

  Future<void> fetchTestToken(streamId,fieldId) async {
    try {
      final response = await NetworkCall().getRequest
        ('user/startTest?fieldId=$fieldId&streamId=$streamId',
          {"Authorization": "Bearer $token",'Content-Type':'application/json'});
      _testtoken = response;

    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}

