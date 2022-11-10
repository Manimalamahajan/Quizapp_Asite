import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/stream_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stream.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../providers/update_profile.dart';

class editprofileform extends StatefulWidget {
  const editprofileform({Key? key}) : super(key: key);
  static final routeName = '/edit';
  @override
  State<editprofileform> createState() => _editprofileformState();
}

class _editprofileformState extends State<editprofileform> {
  final _passwordController = TextEditingController();
  String dropdownCountryValue = '';
  Map all_Streams = {};
  List<dynamic> countryList = [];
  List<Stream?> _selectedStreams = [];
  List<Stream?> streamlist = [];
  List<MultiSelectItem<Stream>> _items = [];
  final _form = GlobalKey<FormState>();
  String _radioValue = '';
  String value1 = "male";
  String value2 = "female";
  var _initValues = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
    'dateOfBirth': '',
    'country': '',
    'gender': '',
    'streamTechIds': '',
    'streamNonTechIds': ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _fetchCountryValues().then((_)=> _fetchStreamValues().then((_) => _fetchInitialValues()).then((_) {
        setState(() {
          _isLoading = false;
        });
      }) );

    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _fetchCountryValues() async {
    var countryProvider = Provider.of<CountryProvider>(context);
    await countryProvider.fetchCountry().then((_) {
      countryList = countryProvider.countryList;
    });
  }

  Future<void> _fetchStreamValues() async {
    final prefs = await SharedPreferences.getInstance();
    all_Streams = json.decode(prefs.getString('streamData')!);
    for (int i = 0; i < all_Streams["steams"].length; i++) {
      final streams = all_Streams["steams"][i]['streams'] as List;
      for (int j = 0; j < streams.length; j++) {
        streamlist.add(Stream(
            id: streams[j]['id'],
            name: streams[j]['name'],
            streamtype: all_Streams["steams"][i]['name'] as String,
            imgurl: streams[j]['url']));
      }
    }
    _items = streamlist
        .map((stream) => MultiSelectItem<Stream>(stream!, stream.name))
        .toList();
  }

  void _fetchInitialValues() {
    Map? initialCountry ;
    final userdetails = ModalRoute.of(context)?.settings.arguments as Map;
   print(userdetails);
    List<int> nonTech = [];
    List<int> tech = [];
    if(userdetails["stream"].length != 0){
      for (int i = 0; i < userdetails["stream"].length; i++) {
        if(userdetails["stream"][i].length != 0){
          final streams = userdetails["stream"][i]['streams'] as List;
          for (int j = 0; j < streams.length; j++) {
            _selectedStreams.add(streamlist.singleWhere((element) {
              return element?.name == streams[j]['name'];
            }));
            if(userdetails["stream"][i]["name"] == "nonTech"){
              nonTech.add(streams[j]['id']);
            } else if(userdetails["stream"][i]["name"] == "tech"){
              tech.add(streams[j]['id']);
            }
          }
        }
      }
    }
    initialCountry =  countryList.singleWhere((element) {
      return element["countryName"] ==  userdetails["country"];

    });

    _initValues = {
      'firstName': userdetails["firstName"],
      'lastName': userdetails["lastName"],
      'email': userdetails["email"],
      'dateOfBirth': userdetails["dateOfBirth"],
      'country': initialCountry!["countryId"].toString(),
      'gender': userdetails["gender"],
      'streamTechIds': tech.join(", "),
      'streamNonTechIds': nonTech.join(", ")
    };

    dropdownCountryValue = userdetails["country"];
    _radioValue = userdetails["gender"];
  }

  @override
  void dispose() {
    dropdownCountryValue = '';
    all_Streams = {};
    countryList = [];
    _selectedStreams = [];
    streamlist = [];
    _items = [];
    super.dispose();
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2022),
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    ).then((pickeddate) {
      if (pickeddate == null) {
        return;
      }
      setState(() {
        _initValues['dateOfBirth'] =
            DateFormat('dd-MM-yyyy').format(pickeddate);
      });
    });
  }

  Future<void> _saveForm() async {
    _form.currentState!.save();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm password'),
        content: TextField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: false,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              _initValues["password"] = _passwordController.value.text;
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
    if (ModalRoute.of(context)?.settings.arguments != null) {
      await Provider.of<Update_Profile>(context, listen: false)
          .saveUserProfile(_initValues);
    }
    Navigator.of(context).pushReplacementNamed("/");
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text('EditProfileForm'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8.0,
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['firstName'] as String,
                        decoration: InputDecoration(labelText: 'First Name'),
                        keyboardType: TextInputType.name,
                        onSaved: (value) {
                          _initValues['firstName'] = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['lastName'] as String,
                        decoration: InputDecoration(labelText: ''),
                        keyboardType: TextInputType.name,
                        onSaved: (value) {
                          _initValues['lastName'] = value!;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Gender",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio<String>(
                                      toggleable: true,
                                      activeColor: Colors.blue,
                                      value: value1,
                                      groupValue: _radioValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioValue = value!;
                                        });
                                        _initValues['gender'] = _radioValue;
                                      }),
                                  Expanded(child: Text('Male'))
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio<String>(
                                      value: value2,
                                      groupValue: _radioValue,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioValue = value!;
                                        });
                                        _initValues['gender'] =
                                            _radioValue.toString();
                                      }),
                                  Expanded(child: Text('Female'))
                                ],
                              ),
                            ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(children: [
                          TextButton.icon(
                            label: Text('Date of birth'),
                            icon: Icon(
                              Icons.calendar_month,
                              semanticLabel: 'Date of birth',
                            ),
                            onPressed: _selectDate,
                          ),
                          Text(_initValues['dateOfBirth'] as String)
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Select Country",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      Container(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          focusColor: Colors.black,
                          value: dropdownCountryValue,
                          icon: const Icon(
                            Icons.arrow_downward,
                            //textDirection: TextDirection.rtl,
                          ),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownCountryValue = value!;
                              int? countryId;
                              if (value != 'country') {
                                for (int i = 0; i < countryList.length; i++) {
                                  if (value == countryList[i]['countryName']) {
                                    countryId = countryList[i]['countryId'];
                                  }
                                }
                                _initValues['country'] = countryId.toString();
                              }
                            });
                          },
                          items: countryList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value['countryName'],
                              child: Text(value['countryName']),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Select Stream",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      Container(
                        width: double.infinity,
                        child: MultiSelectDialogField(
                          onConfirm: (List<Stream?> val) {
                            _selectedStreams = val;
                            List<String> nonTech = [];
                            List<String> tech = [];
                            for (int i = 0; i < _selectedStreams.length; i++) {
                              if (_selectedStreams[i]?.streamtype ==
                                  "Non Technical") {
                                nonTech.add('${_selectedStreams[i]!.id}');
                              } else if (_selectedStreams[i]?.streamtype ==
                                  "Technical") {
                                tech.add('${_selectedStreams[i]!.id}');
                              }
                            }
                            _initValues['streamTechIds'] = tech.join(', ');
                            _initValues['streamNonTechIds'] = nonTech.join(', ');
                          },
                          dialogWidth: MediaQuery.of(context).size.width * 0.7,
                          items: _items,
                          initialValue: _selectedStreams,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
