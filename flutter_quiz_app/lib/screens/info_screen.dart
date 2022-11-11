import 'package:flutter/material.dart';
import './drawer.dart';
import './logout.dart';
import 'package:flutter_svg/svg.dart';
import 'quiz.dart';
import 'package:provider/provider.dart';
import '../providers/test_token.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);
  static final routeName = '/info';

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {



  @override
  Widget build(BuildContext context) {
    final Map ids = ModalRoute.of(context)?.settings.arguments as Map;


    return Scaffold(
      appBar: AppBar(
        title: Text('Test Information'),
        // actions: [
        //   Logout(),
        // ],
      ),
      // drawer: AppDrawer(),
      body: Stack(
        children: [
        SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width:
        double.infinity,),
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
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
                onPressed: () async{
                  final tokenProvider =  Provider.of<TestToken>(context,
                      listen: false);
                  await tokenProvider.fetchTestToken(ids["streamId"], ids["fieldId"]);
                  final String testToken = tokenProvider.testtoken["testToken"];
                  print(testToken);
                  if(testToken.isNotEmpty){
                    Navigator.of(context).pushNamed(QuizScreen
                        .routeName,arguments:{
                      "testToken": testToken,
                      "streamId":ids["streamId"],
                      "fieldId":ids["fieldId"],
                      "streamName":ids["streamName"],
                    } );
                  }
                  },
                child: Text("Start Test"),
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
       ] ),
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
        color: Colors.deepOrangeAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
