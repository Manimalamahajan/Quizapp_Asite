import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class Streamprovider with ChangeNotifier{

  List _streamlist = [];

  List get streamlist {
    return _streamlist;
  }

  Future<void> fetchStream() async {
    try {
      final response = await NetworkCall().getRequest('auth/user/streams',
          {'Content-Type':'application/json'});
      _streamlist = response;

    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}

