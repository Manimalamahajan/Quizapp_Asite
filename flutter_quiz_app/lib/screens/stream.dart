import 'dart:convert';
import 'package:flutter/material.dart';
import './drawer.dart';
import './logout.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/stream_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);
  static final routeName = '/stream';

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  var _isInit = true;
  Map all_Streams ={};
  List techStream = [];
  List nontechStream = [];
  @override
  void initState() {

    super.initState();
  }
  @override
  void didChangeDependencies() async{
    if (_isInit) {
      final prefs = await SharedPreferences.getInstance();
      all_Streams =
      json.decode(prefs.getString('streamData')!);
      techStream = all_Streams["steams"][0]["streams"];
      nontechStream = all_Streams["steams"][1]["streams"];

      setState(() {

      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streams'),
        actions: [
          Logout(),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
          children: [
          SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width: double.infinity,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Text('Technical Streams', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                ),

                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  itemCount: techStream.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => null,
                      splashColor: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        //padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              techStream[index]["name"],
                              style: TextStyle(color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),

                            ),
                            SizedBox(height: 20,),
                            Image.asset(
                              height: 50,
                              "assets/images/${techStream[index]["url"]}",
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Text('Non-Technical Streams', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                ),
                SizedBox(height: 10,),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  itemCount: nontechStream.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => null,
                      splashColor: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              nontechStream[index]["name"],
                              style: TextStyle(color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),

                            ),
                            SizedBox(height: 20,),
                            Image.asset(
                              height: 50,
                              "assets/images/${nontechStream[index]["url"]}",
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
        ),
        ]),

    );
  }
}
