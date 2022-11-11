import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/providers/update_profile.dart';
import './screens/info_screen.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/dashbord.dart';
import './screens/history.dart';
import './screens/profile.dart';
import './screens/stream.dart';
import './screens/score.dart';
import './screens/logout.dart';
import './screens/quiz.dart';
import './screens/editprofilescreen.dart';
import './screens/splash_screen.dart';
import './providers/country_provider.dart';
import './providers/stream_provider.dart';
import './providers/interested_stream_provider.dart';
import './providers/user_profile.dart';
import './providers/short_profile.dart';
import './providers/user_profile.dart';
import './providers/test_token.dart';
import './providers/get_questions.dart';
import './providers/attempt_count.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider.value(
        value: Auth(),
    ),

    ChangeNotifierProvider.value(
    value: CountryProvider(),
    ),
          ChangeNotifierProvider.value(
            value: Streamprovider(),
          ),

          ChangeNotifierProxyProvider<Auth, InterestedStream>(
            create: (_) => InterestedStream(""),
            update: (ctx, auth, previousStreams) => InterestedStream(
              auth.token != null ? auth.token! : "",
            ),
          ),
          ChangeNotifierProxyProvider<Auth, UserProfile>(
            create: (_) => UserProfile(""),
            update: (ctx, auth, previousStreams) => UserProfile(
              auth.token != null ? auth.token! : "",
            ),
          ),
          ChangeNotifierProxyProvider<Auth, ShortProfile>(
            create: (_) => ShortProfile(""),
            update: (ctx, auth, previousStreams) => ShortProfile(
              auth.token != null ? auth.token! : "",
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Update_Profile>(
            create: (_) => Update_Profile(""),
            update: (ctx, auth, previousStreams) => Update_Profile(
              auth.token != null ? auth.token! : "",
            ),
          ),
          ChangeNotifierProxyProvider<Auth, TestToken>(
            create: (_) => TestToken(""),
            update: (ctx, auth, previousStreams) => TestToken(
              auth.token != null ? auth.token! : "",
            ),
          ),
          ChangeNotifierProxyProvider<Auth, GetQuestions>(
            create: (_) => GetQuestions(""),
            update: (ctx, auth, previousStreams) => GetQuestions(
              auth.token != null ? auth.token! : "",
            ),
          ),
          ChangeNotifierProxyProvider<Auth, AttemptCount>(
            create: (_) => AttemptCount(""),
            update: (ctx, auth, previousStreams) => AttemptCount(
              auth.token != null ? auth.token! : "",
            ),
          ),
        ],
       child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner:false,
         title: 'MyShop',
            theme: ThemeData(primarySwatch: Colors.indigo),
         home: auth.isAuth ? Dashbord():FutureBuilder(
           future: auth.tryAutoLogin(),
           builder: (ctx, authResultSnapshot) =>
           authResultSnapshot.connectionState ==
               ConnectionState.waiting
               ? SplashScreen()
               : AuthScreen(),
         ),
            routes: {
              StreamScreen.routeName: (ctx) => StreamScreen(),
              HistoryScreen.routeName: (ctx) => HistoryScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              InfoScreen.routeName: (ctx) => InfoScreen(),
              ScoreSreen.routeName: (ctx) => ScoreSreen(),
              QuizScreen.routeName: (ctx) => QuizScreen(),
              Logout.routeName: (ctx) => Logout(),
              editprofileform.routeName: (ctx) => editprofileform(),
            }
      ),
    ),
        );
  }
}