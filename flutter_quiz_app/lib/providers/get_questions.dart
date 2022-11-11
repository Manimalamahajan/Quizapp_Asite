import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class GetQuestions with ChangeNotifier{
  final String token;
  GetQuestions(this.token);
  List _questionsList = [];

  List get questionsList {
    return _questionsList;
  }

  Future<void> fetchTestQuestions(streamId,fieldId,testToken) async {
    try {
      final response = await NetworkCall().getRequest
        ('user/get/testQuestions?fieldId=$fieldId&streamId=$streamId',
          {"TestToken":"$testToken","Authorization": "Bearer $token",'Content-Ty'
              'pe':'application/json'});
      _questionsList = response;

    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}

