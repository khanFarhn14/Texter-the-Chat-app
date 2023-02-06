import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) 
  {
    //run the intialization for web
    await Firebase.initializeApp
    (
      options: FirebaseOptions
      (
        apiKey: Constants.apiKey,
        appId: Constants.appId,
        messagingSenderId: Constants.messagingSenderId,
        projectId: Constants.projectId
      )
    );
  } else {
    //run the intialization for android, ios
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget 
{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> 
{
  
  bool _isSignedIn = false;

  @override
  void initState()
  {
    (
      super.initState()
    );
    //Checking if the user is LoggedIn or not
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async
  {
    await HelperFunctions.getUserLoggedInStatus().then
    (
      (value)
      {
        if(value != null)
        {
          //change
          setState(() {
            _isSignedIn = value;
            
          });
          // print(value);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp
      (
        theme: ThemeData
        (
          primarySwatch: Palette.kToDark,
        ),
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? const HomePage() : const LoginPage(),
      ),
      designSize: const Size(390,844),
    );
  }
}


class Palette { 
  static const MaterialColor kToDark = MaterialColor(0xff0EF6CC,<int, Color>
  { 
    50: Color(0xffce5641 ),//10% 
    100: Color(0xffb74c3a),//20% 
    200: Color(0xffa04332),//30% 
    300: Color(0xff89392b),//40% 
    400: Color(0xff733024),//50% 
    500: Color(0xff5c261d),//60% 
    600: Color(0xff451c16),//70% 
    700: Color(0xff2e130e),//80% 
    800: Color(0xff170907),//90% 
    900: Color(0xff000000),//100% 
    }, 
  ); 
}