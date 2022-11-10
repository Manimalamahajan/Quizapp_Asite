import 'package:flutter/material.dart';
import '../providers/short_profile.dart';
import './history.dart';
import './profile.dart';
import './stream.dart';
import 'package:provider/provider.dart';
import '../providers/short_profile.dart';

class AppDrawer extends StatefulWidget {
   AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _isInit = true;
  Map shortProfileList ={};
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
      var shortProfile = Provider.of<ShortProfile>(context);
      shortProfile.fetchShortProfile().then((_) {
        shortProfileList = shortProfile.shortProfile;
        print(shortProfileList);

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              'Hello ${shortProfileList["firstName"]}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashbord'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          ListTile(
            leading: Icon(Icons.view_stream),
            title: Text('Stream'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(StreamScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HistoryScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
