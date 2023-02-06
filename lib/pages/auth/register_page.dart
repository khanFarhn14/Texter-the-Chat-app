import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widgets/textstyle.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //Spacing Between Elements
  int four = 4;
  int eight = 8;
  int sixteen = 16;
  int twentyfour = 24;
  int thrityTwo = 32;
  
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String email = "";
  String password = "";
  String fullName = "";

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser
    (
      gestures: 
      const [
        // GestureType.onTap,
        GestureType.onVerticalDragDown,
      ],
      child: Scaffold
      (
        //Change the background color to transparent
        backgroundColor: GiveStyle().dominant,
        body: _isLoading ? Center(child: CircularProgressIndicator(color: GiveStyle().cta)) : SingleChildScrollView
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
                  
                  Center(child: SvgPicture.asset('assets/SignUpImage_svg.svg')),
                  SizedBox(height:8.h),
                  //Welcome back to Texxter
                  Center(child: Text("Welcome to Texter",style: GiveStyle().pageIntro().copyWith(color: GiveStyle().cta),)),
                  SizedBox(height: thrityTwo.h,),

                  Text
                  (
                    "Sign In",
                    style: GiveStyle().pageHeading(),
                  ),
                  
                  SizedBox(height: eight.h,),

                  Text
                  (
                    "Create your account",
                    style: GiveStyle().pageHeadingDescription(),
                  ),

                  SizedBox(height: thrityTwo.h,),

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
                          "Name",
                          style: GiveStyle().normal()
                        ),

                        SizedBox(height: eight.h,),

                        // Name
                        TextFormField
                        (
                          cursorColor: GiveStyle().secondary,
                          style: GiveStyle().inputText(),
                          decoration: textInputDecoration.copyWith
                          (
                            labelText: 'Your Beautiful Name',
                          ),

                          onChanged: (val)
                          {
                            setState(() {
                              fullName = val;
                            });
                          },

                          //Suggest Email Address
                          keyboardType: TextInputType.emailAddress,

                          //This will show done in keyboard
                          textInputAction: TextInputAction.done,

                          //Validator
                          validator: (val)
                          {
                            if(val!.isNotEmpty)
                            {
                              return null;
                            }else{
                              return "You forget to enter your Name!";
                            }
                          },
                        ),

                        SizedBox(height: twentyfour.h,),

                        Text
                        (
                          "Email",
                          style: GiveStyle().normal()
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

                        SizedBox(height: eight.h,),

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
                        "Sign In",
                        style: GiveStyle().normal().copyWith
                        (
                          fontFamily: 'Product Sans Bold',
                          color: GiveStyle().dominant
                        ),
                      ),
                      onPressed: () 
                      {
                        register();
                      },
                    )
                  ),

                  SizedBox(height: 16.h,),

                  Center
                  (
                    child: Text.rich
                    (
                      TextSpan
                      (
                      text: "Already have an account?  ",
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
                          text: "Log In",
                          style: TextStyle
                          (
                            fontFamily: 'Product Sans',
                            color: GiveStyle().cta,
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {nextScreen(context, const LoginPage());}
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
    );
  }

  register() async
  {
    if(formKey.currentState!.validate())
    {
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async
      {
        if(value == true)
        {
          //Saving the shared Preference
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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