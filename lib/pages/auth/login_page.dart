import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/textstyle.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';
class LoginPage extends StatefulWidget 
{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
{
  //Spacing Between Elements
  int four = 4;
  int eight = 8;
  int sixteen = 16;
  int twentyfour = 24;
  int thrityTwo = 32;

  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: KeyboardDismisser
      (
        gestures: 
        const [
          GestureType.onTap,
          GestureType.onVerticalDragDown,
        ],
        child: Scaffold
        (
          //Change the background color to transparent
          backgroundColor: GiveStyle().dominant,
          body: _isLoading ? Center(child: CircularProgressIndicator(color: GiveStyle().cta)):SingleChildScrollView
          (
            child: Padding
            (
              padding: EdgeInsets.fromLTRB(20.w,48.h,20.w,24.h),
              child: Form
              (
                key: formKey,
                child: Column
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
                  [
                    Center(child: Image.asset("assets/LoginImage.png")),
                    SizedBox(height: 8.h,),

                  Center(child: Text("Welcome back to Texter",style: GiveStyle().pageIntro().copyWith(color: GiveStyle().cta),)),
                  SizedBox(height: thrityTwo.h,),


                    Text
                    (
                      "Login",
                      style: GiveStyle().pageHeading(),
                    ),
                    
                    SizedBox(height: eight.h,),
        
                    Text
                    (
                      "Access your account",
                      style: GiveStyle().pageHeadingDescription(),
                    ),

                    SizedBox(height: twentyfour.h,),

                    Center
                    (
                      child: Column
                      (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                          Text
                          (
                            "Email",
                            style: GiveStyle().normal(),
                            // wid
                          ),
                      
                          SizedBox(height: eight.h,),
                      
                          // Email
                          TextFormField
                          (
                            cursorColor: GiveStyle().secondary,
                            style: GiveStyle().inputText(),
                            decoration: textInputDecoration.copyWith
                            (
                              labelText: 'Enter your email',
                            ),
                      
                            onChanged: (val)
                            {
                              setState(() {
                                email = val;
                              });
                            },
                      
                            //Suggest Email Address
                            keyboardType: TextInputType.emailAddress,
                      
                            //This will show done in keyboard
                            textInputAction: TextInputAction.done,
                      
                            //Validator
                            validator: (value)
                            {
                              if(value!.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                              {
                                return "Please enter a valid Email!";
                              }else{
                                return null;
                              }
                            },
                          ),
                      
                          SizedBox(height: twentyfour.h,),
                      
                          Text
                          (
                            "Password",
                            style: GiveStyle().normal()
                          ),
                      
                          SizedBox(height: 8.h,),
                      
                          //Password TextFormField
                          TextFormField
                          (
                            //Style
                            cursorColor: GiveStyle().secondary,
                      
                            //for password hide
                            obscureText: _obscureText,
                            
                            style: GiveStyle().inputText(),
                            decoration: textInputDecoration.copyWith
                            (
                              labelText: 'Enter your password',
                              suffixIcon: GestureDetector
                              (
                                onTap: ()
                                {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText ? Icons.visibility: Icons.visibility_off)
                              )
                            ),
                      
                            //Suggest Email Address
                            keyboardType: TextInputType.emailAddress,
                      
                            //This will show done in keyboard
                            textInputAction: TextInputAction.done,
                      
                            //setting the password
                            onChanged: (val)
                            {
                              setState(() {
                                password = val;
                              });
                            },
                      
                            //Validator
                            validator: (value)
                            {
                              if(value!.length < 6)
                              {
                                return "Password must be atleast 6 characters!";
                              }else{
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
        
                    SizedBox(height: 110.h,),

                    //Button
                    SizedBox
                    (
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton
                      (
                        style: ElevatedButton.styleFrom
                        (
                          backgroundColor: GiveStyle().cta,
                          elevation: 0,
                          shape: RoundedRectangleBorder
                          (
                            borderRadius: BorderRadius.circular(30)
                          )
                        ),
                        child: Text
                        (
                          "Log In",
                          style: GiveStyle().normal().copyWith
                          (
                            fontFamily: 'Product Sans Bold',
                            color: GiveStyle().dominant
                          ),
                        ),
                        onPressed: () 
                        {
                          login();
                        },
                      )
                    ),
    
                    SizedBox(height: sixteen.h,),

                    //Don't have an account? Sign In
                    Center
                    (
                      child: Text.rich
                      (
                        TextSpan
                        (
                        text: "Don't have an account?  ",
                        style: TextStyle
                        (
                          fontFamily: 'Product Sans',
                          color: GiveStyle().secondary_70,
                          fontSize: 12,
                        ),
                        children: <TextSpan>
                        [
                          TextSpan
                          (
                            text: "Sign In",
                            style: TextStyle
                            (
                              fontFamily: 'Product Sans',
                              color: GiveStyle().cta,
                              fontSize: 12,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {nextScreen(context, const RegisterPage());}
                          )
                        ]
    
                        )
                      ),
                    )
                  ],
                ),
              )
            ),
          )
        ),
      ),
    );
  }

  login() async
  {
    if(formKey.currentState!.validate())
    {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password).then((value) async
      {
        if(value == true)
        {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettinUserData(email);
          //Saving the Value to Shared Preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomePage());
        }else
        {
          showSnackbar(context, Colors.red.withOpacity(0.5), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}