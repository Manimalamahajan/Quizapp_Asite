import 'package:flutter/material.dart';
import '../network/network_calls.dart';

class CountryProvider with ChangeNotifier{

  List _countryList = [];

  List get countryList {
    return _countryList;
  }

  Future<void> fetchCountry() async {
    try {
      final response = await NetworkCall().getRequest('auth/user/countries',
          {'Content-Type':'application/json'});
      _countryList = response;

    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}

