import 'package:flutter/material.dart';
import './drawer.dart';
import './logout.dart';
import 'package:flutter_svg/svg.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static final routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        actions: [
          Logout(),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
        SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width: double.infinity,),
      SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 10,
            ),
                 SizedBox(
                 height: 10,
            ),
                Card(
                 elevation: 10,
                 margin: EdgeInsets.symmetric(
                   vertical: 5,
                  horizontal: 15,
              ),
                  child: Padding(
                   padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                ),
                    child: Row(
                      children:[ Image.asset(
                        height:80,
                        "assets/images/Flutter.jpg",
                  ),
                       SizedBox(width: 100,),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Text(
                            "Flutter",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                            SizedBox(height: 20,),
                            Text(
                            "Total Attempt : 112",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                            Text(
                            "Date : 28-02-2002",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                    ],
                  ),
                       ),
                      ]),
                ),
              ),

                Card(
                  elevation: 20,
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Row(
                        children:[ Image.asset(
                          height:80,
                          "assets/images/html.png",
                        ),
                          SizedBox(width: 100,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HTML",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  "Total Attempt : 112",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  "Date : 28-02-2002",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
          ]),
        ),])

    );
  }
}