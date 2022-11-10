import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);
  static final routeName = '/quiz';
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? option;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quiz Screen"),
        ),
        body: Stack(children: [
          SvgPicture.asset("assets/images/bg.svg",
              fit: BoxFit.fill, width: double.infinity),
          Column(
            children: [
              SizedBox(height: 30,),
          Card(
          child: ListTile(
          leading: Text("Stream: Flutter", style: TextStyle(fontSize:
          18, fontWeight: FontWeight.bold),),
            trailing: Text(
              "Attempt: First", style: TextStyle(fontSize: 18, fontWeight:
            FontWeight.bold),
            ),),
          ),
          SizedBox(height: 40,),
          Card(child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text("Q-1: Flutter is an open-source UI software "
                  "development kit "
                  "created by", style: TextStyle(fontSize: 18, fontWeight:
              FontWeight.bold),),
            ),
            Divider(),

            RadioListTile(
              title: Text("option1"),
              value: "option1",
              groupValue: option,
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            ),

            RadioListTile(
              title: Text("option2"),
              value: "option2",
              groupValue: option,
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            ),

            RadioListTile(
              title: Text("option3"),
              value: "option3",
              groupValue: option,
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text("option4"),
              value: "option4",
              groupValue: option,
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            )
          ],),),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: null, child: Text("Save & Next"),
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all
              (Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.indigo)),)
        ],
        )
        ]));
  }
}
