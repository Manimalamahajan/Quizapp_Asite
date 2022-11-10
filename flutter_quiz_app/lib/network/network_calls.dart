import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkCall {
  NetworkCall();

  final _baseUrl = 'http://192.168.102.92:8090/';
  String get baseUrl {
    return _baseUrl;
  }

 getRequest(urlPath, header) async{
    final url = Uri.parse(_baseUrl + urlPath);
    final response = await http.get(
      url,
      headers: header,
    );
    return json.decode(response.body);
  }

  postRequest(urlPath, authInfo, header) async{
    final url = Uri.parse(_baseUrl + urlPath);
    final response = await http.post(
      url,
      body: json.encode(
        authInfo,
      ),
      headers: header,
    );
    return json.decode(response.body);
  }
}