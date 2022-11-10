import 'package:flutter/material.dart';
import './drawer.dart';
import './logout.dart';
import 'package:flutter_svg/svg.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);
  static final routeName = '/info';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Information'),
        actions: [
          Logout(),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
        SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width:
        double.infinity,),
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'RULES AND REGULATION',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'Test contains 30 questions each contains 1 mark.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'Maximum number of time you can attempt quiz is 3.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'All the questions are of MCQ type.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'All the questions are compulsory.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'Time limit to complete the test is 45 mins.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'You should submit the test within the time limit or else your test will not be considered.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'Once you have saved the answer you cannot change it.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'You cannot move to the next question without giving the answer of the current one.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text(
                'Once started you cannot quit the test so you have to give the answer and submit the quiz.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white,),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: null,
                child: Text("Start Test"),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(8),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white)))
          ],
        ),
      ),]
      ));
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      decoration: new BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
    );
  }
}
