import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);
  static final routeName = '/logout';
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        items: [
          DropdownMenuItem(
            child: Container(
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Logout")
                ],
              ),
            ),
            value: 'logout',
          ),
        ],
        onChanged: (itemid) {
          Navigator.of(context).pushReplacementNamed('/');
          Provider.of<Auth>(context, listen: false).logout();

        }
    );
  }
}
