import 'package:shared_preferences/shared_preferences.dart';

class SharedData {

  addTokenToSF(_token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token );
  }

  getTokenValueSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('token');
    return stringValue;
  }
  clearPreferences() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }
}