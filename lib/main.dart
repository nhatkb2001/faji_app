import 'package:faji_app/views/authentication/signIn.dart';
import 'package:faji_app/views/profile/changingPassword.dart';
import 'package:faji_app/views/profile/edittingProfile.dart';
import 'package:flutter/material.dart';
// Import the generated file
import 'package:firebase_core/firebase_core.dart';

//import others
import 'package:shared_preferences/shared_preferences.dart';

int initScreen = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = (preferences.getInt('initScreenstore') ?? 0);
  await preferences.setInt('initScreen', 1);
  await Firebase.initializeApp();
  runApp(FerceApp());
}

class FerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferce',
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        dialogBackgroundColor: Colors.white,
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Colors.black,
      ),
      initialRoute: initScreen == 0 || initScreen == null ? 'signin' : 'signin',
      routes: {
        'signin': (context) => signInScreen(),
        'changingPW': (context) => changingPasswordScreen(),
      },
    );
  }
}
