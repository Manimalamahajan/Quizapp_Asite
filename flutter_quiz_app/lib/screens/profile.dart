import 'package:flutter/material.dart';
import './drawer.dart';
import 'package:flutter_svg/svg.dart';
import './editprofilescreen.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile.dart';
import './logout.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static final routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isInit = true;
  Map userProfileList ={};
  List useInterestedStream = [];
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
      var profileProvider = Provider.of<UserProfile>(context);
      profileProvider.fetchUserProfile().then((_) {
        userProfileList = profileProvider.userProfileList;
        if(userProfileList["InterestedStream"].length != 0 &&
            userProfileList["InterestedStream"] != "No data Found") {
          for (int i = 0; i < userProfileList["InterestedStream"].length; i++) {
            if(userProfileList["InterestedStream"][i].length != 0) {
              final streams = userProfileList["InterestedStream"][i]['streams'];

              for (int j = 0; j < streams.length; j++) {
                useInterestedStream.add({
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
          title: Text('Profile'),
          actions: [
            Logout(),
          ],
        ),
       drawer: AppDrawer(),
       body:
       Stack(
         children: [
         SvgPicture.asset("assets/images/bg.svg", fit: BoxFit.fill,width: double.infinity,),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child:_isLoading?Center(child: CircularProgressIndicator()): Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: Text('Basic details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                    ),
                    ElevatedButton(onPressed: (){Navigator.of(context).pushNamed(editprofileform.routeName, arguments: {
                      'firstName': userProfileList["firstName"],
                      'lastName': userProfileList["lastName"],
                      'email': userProfileList["email"],
                      'dateOfBirth': userProfileList["dateOfBirth"],
                      'country': userProfileList["country"],
                      'gender': userProfileList["gender"],
                      'stream': userProfileList["InterestedStream"] == 'No data Found'? []:userProfileList["InterestedStream"],
                    });}, child: Text('Edit profile')),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    child: DataTable(
                      // Datatable widget that have the property columns and rows.
                        columns: [
                          // Set the name of the column
                          DataColumn(label: Text('Name'),),
                          DataColumn(label: Text('Email'),),
                          DataColumn(label: Text('Birth Date'),),
                          DataColumn(label: Text('Country'),),
                          DataColumn(label: Text('Gender'),),

                        ],
                        rows:[
                          // Set the values to the columns
                          DataRow(cells: [
                            DataCell(Text(userProfileList["firstName"]
                            )),
                            DataCell(Text(userProfileList["email"])),
                            DataCell(Text(userProfileList["dateOfBirth"])),
                            DataCell(Text(userProfileList["country"])),
                            DataCell(Text(userProfileList["gender"].toString().split(".").last)),
                          ]),

                        ]
                    ),
                  ),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text('Intrested Streams', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
            ),
                GridView.builder(
                padding: EdgeInsets.all(20),
                shrinkWrap: true,
                itemCount: useInterestedStream.length,
                itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => null,
                  splashColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                    useInterestedStream[index]["streamName"],
                          style: TextStyle(color: Colors.black87, fontWeight:
                          FontWeight.bold, fontSize: 22),

                        ),
                        SizedBox(height: 20,),
                        Image.asset(
                          height:50,
                          "assets/images/${useInterestedStream[index]["streamimgUrl"]}",
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
            ]
            ),
          ),
        ]
    ),
    );
  }
}