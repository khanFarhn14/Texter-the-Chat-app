import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/profile_page.dart';
import 'package:chat_app/pages/auth/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widgets/textstyle.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState()
  {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async
  {
    //Getting UserEmail from Helper function and assigning them to email
    await HelperFunctions.getUserEmailFromSF().then
    (
      (value)
      {
        setState(() {
          email = value!;
        });
      }
    );

    //Getting UserName from Helper function and assigning them to userName
    await HelperFunctions.getUserNameFromSF().then
    (
      (value)
      {
        setState(() {
          userName = value!;
        });
      }
    );
  }
  Widget build(BuildContext context) {
    return Theme
    (
      data: ThemeData(primaryIconTheme: IconThemeData(color: GiveStyle().secondary)),
      child: Scaffold 
      (
        
        backgroundColor: GiveStyle().dominant,
        appBar: AppBar
        (
          actions:
          [
            IconButton
            (
              onPressed:() => nextScreen(context, const SearchPage()),
              icon: const Icon(Icons.search),
            )
          ],
          shape: Border
          (
            bottom: BorderSide
            (
              color: GiveStyle().cta,
              width: 2
            ),
          ),
          centerTitle: true,
          title: Text("Room",style: GiveStyle().inputText().copyWith(color: GiveStyle().secondary)),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: Drawer
        (
          backgroundColor: GiveStyle().dominantDark,
          child: ListView
          (
            padding: EdgeInsets.fromLTRB(20.w, 125.h, 20.w, 20.h),
            children: 
            [
              Image.asset('assets/AccountProfile.png',height: 60.h,),
              SizedBox(height: 8.h,),
              Text(userName,textAlign: TextAlign.center,style: GiveStyle().pageHeading(),),
              SizedBox(height: 16.h,),
              Divider
              (
                height: 5,
                color: GiveStyle().cta,
              ),

              //Room
              ListTile
              (
                onTap: (){},
                selectedColor: GiveStyle().secondary,
                selected: true,
                leading: const Icon(Icons.door_back_door_outlined),
                title: Text("Rooms",style: GiveStyle().normal(),),
              ),

              //Profile
              ListTile
              (
                onTap: ()
                {
                  nextScreenReplace(context, const ProfilePage());
                },
                selectedColor: GiveStyle().secondary_50,
                selected: true,
                leading: const Icon(Icons.account_circle_outlined),
                title: Text("Profile",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_50),),
              ),

              //Logout
              ListTile
              (
                onTap: () async
                {
                  showDialog(context: context, builder: (context)
                  {
                    return const CallToAction();
                  });
                  // authService.signOut().whenComplete(() => nextScreenReplace(context, const LoginPage()));
                },
                selectedColor: GiveStyle().secondary_50,
                selected: true,
                leading: const Icon(Icons.exit_to_app),
                title: Text("Logout",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_50),),
              ),
            ],
          )
        ),
      ),
    );
  }
}