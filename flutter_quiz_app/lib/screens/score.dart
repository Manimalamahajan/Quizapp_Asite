import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import './logout.dart';
import './drawer.dart';

class ScoreSreen extends StatelessWidget {
  const ScoreSreen({Key? key}) : super(key: key);
  static final routeName = '/score';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Dashbord'),
        actions: [
          Logout(),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
      children: [
      SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width: double.infinity,),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Score :', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 45),),
        Text('80/100', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),),
      ],
      ),
    ),
    ]
    ),
    );
  }
}
