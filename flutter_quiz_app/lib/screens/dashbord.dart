import 'package:flutter/material.dart';
import '../models/shared_preferences.dart';
import './drawer.dart';
import 'package:flutter_svg/svg.dart';
import './logout.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/interested_stream_provider.dart';


class Dashbord extends StatefulWidget {
   Dashbord({Key? key}) : super(key: key);

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  var _isInit = true;
  List interested_Streams =[];
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
      var interestedstreamProvider = Provider.of<InterestedStream>(context);
      interestedstreamProvider.fetchInterestedStreams().then((_) {
        if (interestedstreamProvider.interestedStreamsList.isNotEmpty) {
        for (int i = 0; i <
            interestedstreamProvider.interestedStreamsList.length; i++) {
          final streams = interestedstreamProvider
              .interestedStreamsList[i]['streams'];
          if (interestedstreamProvider.interestedStreamsList[i].length != 0) {
          for (int j = 0; j < streams.length; j++) {
            interested_Streams.add({
              "streamName": streams[j]["name"],
              "streamimgUrl": streams[j]["url"],
            });
          }
        }
      }
          }
        setState(() {
          _isLoading = false;
        });
      });
      }
    _isInit = false;

    super.didChangeDependencies();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
       Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text('Interested Streams', style: TextStyle(color:
                Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
              ),
              _isLoading?Center(child: CircularProgressIndicator()):
              GridView.builder(
                padding: EdgeInsets.all(20),
                shrinkWrap: true,
                itemCount: interested_Streams.length,
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
                            interested_Streams[index]["streamName"],
                            style: TextStyle(color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),

                          ),
                          SizedBox(height: 20,),
                          Image.asset(
                            height: 50,
                            "assets/images/${interested_Streams[index]["streamimgUrl"]}",
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
            ],
          ),
        ],
      ),
    );
  }
}
