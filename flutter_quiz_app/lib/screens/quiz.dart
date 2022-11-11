import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/get_questions.dart';
import '../providers/attempt_count.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);
  static final routeName = '/quiz';
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var _isInit = true;
  var _isLoading = false;
   Map args ={};
   int attemptCount = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async{
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await _fetchQuestions();
      await _fetchAttemptInfo();

        setState(() {
          _isLoading = false;
        });


    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _fetchQuestions() async{
     args = ModalRoute.of(context)?.settings.arguments as Map;
    final questionProvider =  Provider.of<GetQuestions>(context);
    await questionProvider.fetchTestQuestions(args["streamId"],
      args["fieldId"],args["testToken"]);
    final List questionsList = questionProvider.questionsList;
    print(questionsList);
  }
  Future<void> _fetchAttemptInfo() async{

    final attemptProvider =  Provider.of<AttemptCount>(context,listen: false);
    await attemptProvider.fetchAttemptCount();
    final List attemptList = attemptProvider.attemptList;
    print(attemptList);

    setState(() {
      attemptCount = attemptList.length + 1;
    });


  }

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
          leading: Text("Stream: ${args["streamName"]}", style: TextStyle
            (fontSize:
          18, fontWeight: FontWeight.bold),),
            trailing: Text(
              "Attempt: $attemptCount", style: TextStyle(fontSize: 18, fontWeight:
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
              value: "",
              groupValue: 'option',
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            ),

            RadioListTile(
              title: Text("option2"),
              value: "",
              groupValue: 'option',
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            ),

            RadioListTile(
              title: Text("option3"),
              value: "",
              groupValue: 'option',
              onChanged: (value) {
                setState(() {
                  //gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text("option4"),
              value: "",
              groupValue: 'option',
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
