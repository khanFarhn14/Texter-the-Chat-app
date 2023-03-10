import 'dart:core';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/textstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages/home_page.dart';

var textInputDecoration = InputDecoration
(
  
  labelStyle: GiveStyle().labelText(),
  floatingLabelBehavior: FloatingLabelBehavior.never,

  filled: true,
  fillColor: GiveStyle().secondary_20,


  enabledBorder: OutlineInputBorder
  (
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide.none,
  ),


  focusedBorder: OutlineInputBorder
  (
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide
    (
      color: GiveStyle().secondary,
      width: 1.8,
    )
  ),


  errorBorder: OutlineInputBorder
  (
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide
    (
      color: Color(0xFFF47979),
      width: 1.9
    )
  ),


  focusedErrorBorder: OutlineInputBorder
  (
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide
    (
      color: Color(0xFFF47979),
      width: 1.9
    )
  ),

  errorStyle: GiveStyle().labelText().copyWith
  (
    color: const Color(0xffFFA5A5),
  )

);


//Move to Next Screen
void nextScreen(context, page)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

//Replace the Next Screen
void nextScreenReplace(context, page)
{
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}


void showSnackbar(context, color, message)
{
  ScaffoldMessenger.of(context).showSnackBar
  (
    SnackBar
    (
      content: Text
      (
        message,
        style: GiveStyle().labelText()
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction
      (
        label: "Ok",
        onPressed: (){},
        textColor: GiveStyle().secondary,
      ),
    )
  );
}


//Call to Action for Logout
class CallToActionLogOut extends StatelessWidget {
  const CallToActionLogOut({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Dialog
    (
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: GiveStyle().secondary_70,width: 2),
      ),
      backgroundColor: GiveStyle().dominant,
      child: SizedBox
      (
        // width: 300.w,
        height: 180.h,
        child: Center
        (
          child: Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              Text("Logout",style: GiveStyle().ctaHeading()),

              SizedBox(height: 4.h,),

              Text("Would you like to log out?",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_70)),

              SizedBox(height: 16.h,),

              //Log Out Button
              GestureDetector
              (
                onTap: (() async{
                  await authService.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
                }),
                child: Container
                (
                  decoration: BoxDecoration
                  (
                    color: GiveStyle().cta,
                    borderRadius: BorderRadius.circular(5.r),
              
                  ),
                  child: Padding 
                  (
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Log Out",style: GiveStyle().normal().copyWith(color: GiveStyle().dominant,fontFamily: 'Product Sans Bold'),)
                    
                  ),
                ),
              ),
              
              SizedBox(height: 8.h,),
              
              //Cancel button
              GestureDetector
              (
                onTap: (() {
                  // print("Tapped");
                  Navigator.pop(context);
                }),
                child: Padding 
                (
                  padding: const EdgeInsets.fromLTRB(20,10,20,10),
                  child: Text("Cancel",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_70),)
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

//Call to Action for Exiting Room
// ignore: must_be_immutable
class CallToActionExitRoom extends StatefulWidget {
  String groupId = "";
  String adminName = "";
  String groupName = "";
  CallToActionExitRoom({super.key, required this.groupId, required this.adminName, required this.groupName});

  
  @override
  State<CallToActionExitRoom> createState() => _CallToActionExitRoomState();
}

class _CallToActionExitRoomState extends State<CallToActionExitRoom> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Dialog
    (
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: GiveStyle().secondary_70,width: 2),
      ),
      backgroundColor: GiveStyle().dominant,
      child: SizedBox
      (
        // width: 300.w,
        height: 180.h,
        child: Center
        (
          child: Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              Text("Exit Room",style: GiveStyle().ctaHeading()),

              SizedBox(height: 4.h,),

              Text("Would you like to Exit the Room?",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_70)),

              SizedBox(height: 16.h,),

              //Log Out Button
              GestureDetector
              (
                onTap: (() async{
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, widget.adminName, widget.groupName).whenComplete(() => nextScreenReplace(context, const HomePage()));
                }),
                child: Container
                (
                  decoration: BoxDecoration
                  (
                    color: GiveStyle().cta,
                    borderRadius: BorderRadius.circular(5.r),
              
                  ),
                  child: Padding 
                  (
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Exit",style: GiveStyle().normal().copyWith(color: GiveStyle().dominant,fontFamily: 'Product Sans Bold'),)
                    
                  ),
                ),
              ),
              
              SizedBox(height: 8.h,),
              
              //Cancel button
              GestureDetector
              (
                onTap: (() {
                  // print("Tapped");
                  Navigator.pop(context);
                }),
                child: Padding 
                (
                  padding: const EdgeInsets.fromLTRB(20,10,20,10),
                  child: Text("Cancel",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_70),)
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}