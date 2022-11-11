import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../models/stream.dart';
import 'package:intl/intl.dart';
import '../providers/country_provider.dart';
import '../providers/stream_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';

List<dynamic> countryList =[];

enum AuthMode { Signup, Login }



class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: AppBar(title: Text("Qiz app"),),
      body: Stack(children: [
        SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width: double.infinity,),
        SingleChildScrollView(
          child: Container(
            width: devicesize.width,
            height:_authMode == AuthMode.Signup?devicesize.height * 1.45:
            devicesize.height,
            child: Column(
              mainAxisAlignment: _authMode == AuthMode.Signup
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(

                  margin: const EdgeInsets.only(bottom: 40.0, top: 80),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 94.0),

                  // ..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange.shade900,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Text(
                    'Quiz',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  height: (_authMode == AuthMode.Signup)?devicesize.height*1.15 :
                  280,
                  child: AuthCard(_switchAuthMode, _authMode),
                ),
              ]            ),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
   AuthCard(this._switchAuthMode, this._authMode, {Key? key})
      : super(key: key);
  final VoidCallback _switchAuthMode;
   AuthMode _authMode;

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {


  final GlobalKey<FormState> _formSignupKey = GlobalKey();
  final GlobalKey<FormState> _formLoginKey = GlobalKey();
  List<Stream?> _selectedStreams = [];
  List streamlist = [];
  List<MultiSelectItem<Stream>> _items = [];
  String dropdownCountryValue = '';
  var _isInit = true;
  String _radioValue = '';
  String value1= "male";
  String value2= "female";

  bool _checkGender = false;
  bool _checkDOB = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if (_isInit) {
      var countryProvider = Provider.of<CountryProvider>(context);
      countryProvider.fetchCountry().then((_) {
        countryList = countryProvider.countryList;
        dropdownCountryValue = countryList[0]['countryName'];
      });
      var streamProvider = Provider.of<Streamprovider>(context);
      streamProvider.fetchStream().then((_) async {
        for(int i = 0; i < streamProvider.streamlist.length; i++) {
          final streams = streamProvider.streamlist[i]['streams'] as List;
          for(int j = 0; j < streams.length; j++) {
            streamlist.add(Stream(id: streams[j]['id'],
                name:streams[j]['name'], streamtype: streamProvider
                    .streamlist[i]['name'] as String,imgurl: streams[j]['url']
            ));
            final prefs = await SharedPreferences.getInstance();
            final streamData = json.encode(
              {
                'steams': streamProvider.streamlist,
              },
            );
            prefs.setString('streamData', streamData);
          }
        }
        _items = streamlist
            .map((stream) => MultiSelectItem<Stream>(stream!, stream.name))
            .toList();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

    Map<String, String> _authLoginData = {
      'email': '',
      'password': '',
    };

    Map<String, String> _authSignUpData = {
      'firstName': '',
      'lastName': '',
      'email': '',
      'password': '',
      'gender': '',
      'country': '',
      'dateOfBirth': '',
      'streamTechIds': '',
      'streamNonTechIds': ''
    };


    var _isLoading = false;
    final _passwordController = TextEditingController();

    Future<void> _saveSignupForm() async {
      bool validator = true;
      bool genderValidator = true;
      bool dobValidator = true;
      if(_authSignUpData["gender"]== ""){
        setState(() {
          _checkGender = true;
        });
        genderValidator = false;
      }

      if ((_authSignUpData["dateOfBirth"] == "")) {
        setState(() {
          _checkDOB = true;
        });
        dobValidator = false;
      }

      var validate = _formSignupKey.currentState?.validate();
      if (!validate!) {
        validator = false;
      }
        if(!validator || !genderValidator || !dobValidator){
          return;
        }
      _formSignupKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      try {

          await Provider.of<Auth>(context, listen: false).signup
            (_authSignUpData).then((value) {
            widget._switchAuthMode;
          });

      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
         _showErrorDialog(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  Future<void> _saveLoginForm() async {

    var validate = _formLoginKey.currentState?.validate();
    if (!validate!) {
      return;
    }
    _formLoginKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
        await Provider.of<Auth>(context, listen: false).login(_authLoginData);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

    void _showErrorDialog(String errormsg) {
      showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: const Text("Error Ocurred"),
                content: Text(errormsg),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("okay"))
                ],
              ));
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
          _authSignUpData['dateOfBirth'] =
              DateFormat('dd-MM-yyyy').format(pickeddate);
          setState(() {
            _checkDOB = false;
          });
        });
      });
    }

    @override
    Widget build(BuildContext context) {
      final devicesize = MediaQuery
          .of(context)
          .size;
      return widget._authMode == AuthMode.Signup
          ? Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
          width: devicesize.width * 100,
          height: devicesize.height,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formSignupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter First name';
                    }
                  },
                  onSaved: (value) {
                    _authSignUpData['firstName'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Last name';
                    }
                  },
                  onSaved: (value) {
                    _authSignUpData['lastName'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authSignUpData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authSignUpData['password'] = value!;
                  },
                ),
                TextFormField(
                  enabled: widget._authMode == AuthMode.Signup,
                  decoration:
                  InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: widget._authMode == AuthMode.Signup
                      ? (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                  }
                      : null,
                ),
                SizedBox(
                  height: 20,
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
                                    _checkGender = false;
                                  });
                                  _authSignUpData['gender'] =
                                      _radioValue.toString();
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
                                    _checkGender = false;
                                  });
                                  _authSignUpData['gender'] =
                                      _radioValue.toString();
                                }),
                            Expanded(child: Text('Female'))
                          ],
                        ),
                      ),
                    ]),
                _checkGender ? Text("Select gender",style: TextStyle(color: Colors
                    .red),):Text(""),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                      children: [
                        TextButton.icon(
                          label: Text('Date of birth'),
                          icon: Icon(
                            Icons.calendar_month,
                            semanticLabel: 'Date of birth',
                          ),
                          onPressed: _selectDate,
                        ),
                        _checkDOB ? Text("Choose date",style:TextStyle(color:
                        Colors.red),)
                            :Text
                          (_authSignUpData['dateOfBirth']!)
                      ]
                  ),
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
                          _authSignUpData['country'] = countryId.toString();
                        }
                      });
                    },
                    items:
                    countryList.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value['countryName'],
                        child: Text(value['countryName']),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(

                  height: 20,
                ),
                Text(
                  "Select Stream",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 17, color: Colors.black45),
                ),
                Container(
                  width: double.infinity,
                  child: MultiSelectDialogField(
                    validator: (List<Stream?>? val){
                      if (val!.isEmpty) {
                      return 'Select Streams';
                    }
                    },
                    onConfirm: (List<Stream?> val) {
                      _selectedStreams = val;
                      List nonTechList = [];
                      List techList = [];
                      String nonTech = '';
                      String tech = '';
                      for (int i = 0;i < _selectedStreams.length; i++) {
                        if (_selectedStreams[i]?.streamtype == "Non Technical") {
                          nonTechList.add(_selectedStreams[i]?.id);
                          nonTech = nonTechList.join(', ');
                          print(nonTech);
                        } else if(_selectedStreams[i]?.streamtype == "Technical") {
                          techList.add(_selectedStreams[i]?.id);
                          tech = techList.join(', ');
                          print(tech);
                        }
                      }
                      _authSignUpData['streamTechIds'] = tech;
                      _authSignUpData['streamNonTechIds'] = nonTech;
                    },
                    dialogWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                    items: _items,
                    initialValue:
                    _selectedStreams, // setting the value of this in initState() to pre-select values.
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            child: Text('SIGN UP'),
                            onPressed: _saveSignupForm,
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(
                                  Colors.deepOrangeAccent),
                              foregroundColor:
                              MaterialStateProperty.all(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            child: Text('LOGIN INSTEAD'),
                            onPressed: widget._switchAuthMode,
                          ),
                        ]))
              ],
            ),
          ),
        ),
      )
          : Container(
        height: 280,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Container(
            width: devicesize.width * 100,
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formLoginKey,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'E-Mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                        },
                        onSaved: (value) {
                          _authLoginData['email'] = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authLoginData['password'] = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        child: Text("Login"),
                        onPressed: _saveLoginForm,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.deepOrangeAccent),
                          foregroundColor:
                          MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        child: Text('SIGNUP INSTEAD'),
                        onPressed: widget._switchAuthMode,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      );
    }
  }


