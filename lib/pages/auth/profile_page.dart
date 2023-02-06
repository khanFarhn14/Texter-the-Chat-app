import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/textstyle.dart';
import '../../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  @override
  Widget build(BuildContext context) {
    return Theme
    (
      data: ThemeData(primaryIconTheme: IconThemeData(color: GiveStyle().secondary)),
      child: Scaffold
      (
        backgroundColor: GiveStyle().dominant,
        appBar: AppBar
        (
          shape: Border
          (
            bottom: BorderSide
            (
              color: GiveStyle().cta,
              width: 2
            ),
          ),
          centerTitle: true,
          title: Text("Profile",style: GiveStyle().inputText().copyWith(color: GiveStyle().secondary)),
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
                  onTap: ()
                  {
                    nextScreenReplace(context, const HomePage());
                  },
                  selectedColor: GiveStyle().secondary_50,
                  selected: true,
                  leading: const Icon(Icons.door_back_door_outlined),
                  title: Text("Rooms",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_50),),
                ),
    
                //Profile
                ListTile
                (
                  onTap: ()
                  {
                    nextScreenReplace(context, const ProfilePage());
                  },
                  selectedColor: GiveStyle().secondary,
                  selected: true,
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text("Profile",style: GiveStyle().normal()),
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

        body: Padding
        (
          padding: EdgeInsets.symmetric(vertical: 62.h, horizontal: 16.w),
          child: Column
          (
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              // Icon(Icons.account_circle_rounded,color: GiveStyle().secondary,size: 50,)
              Center(child: Image.asset('assets/ProfilePic.png')),
              SizedBox(height: 20.h,),
              Row
              (
                children: 
                [
                  Text("Full Name",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_70),),
                  SizedBox(width: 32.w,),
                  Text(userName,style: GiveStyle().normal(),)
                ],
              ),

              SizedBox(height: 16.h,),

              Row
              (
                children: 
                [
                  Text("Email Id",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_70),),
                  SizedBox(width: 45.w,),
                  Text(email,style: GiveStyle().normal(),)
                ],
              )
            ],
          )
        )
      ),
    );
  }
}