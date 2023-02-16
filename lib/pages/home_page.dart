import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/profile_page.dart';
import 'package:chat_app/pages/auth/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/textstyle.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState()
  {
    super.initState();
    gettingUserData();
  }

  //String Manipulation
  //Getting User Id
  String getId(String res)
  {
    return res.substring(0, res.indexOf("_"));
  }

  //Getting user Name
  String getName(String res)
  {
    return res.substring(res.indexOf("_")+1);
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

    //Getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshots){
      setState(() {
        groups = snapshots;
      });
    });
  }
  Widget build(BuildContext context) 
  {
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
              SvgPicture.asset("assets/AccountProfile_svg.svg"),

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
                    return const CallToActionLogOut();
                  });
                },
                selectedColor: GiveStyle().secondary_50,
                selected: true,
                leading: const Icon(Icons.exit_to_app),
                title: Text("Logout",style: GiveStyle().normal().copyWith(color: GiveStyle().secondary_50),),
              ),
            ],
          )
        ),

        body: groupList(),
        floatingActionButton: FloatingActionButton
        (
          onPressed: ()
          {
            // CallToActionCreateGroup(context);
            showDialog(context: context, builder: (context)
            {
              return CallToActionCreateGroup(_isLoading);
            });
          },
          elevation: 0,
          backgroundColor: GiveStyle().cta,
          child: Icon(Icons.add,color: GiveStyle().dominant,size: 30,),
        ),
      ),
    );
  }

  //Group List Function
  groupList()
  {
    return StreamBuilder
    (
      stream: groups,
      builder: (context, AsyncSnapshot snapshot)
      {
        //Make some checks
        if(snapshot.hasData)
        {
          if(snapshot.data['groups'] != null)
          {
            if(snapshot.data['groups'].length != 0)
            {
              return ListView.builder
              (
                itemCount: snapshot.data['groups'].length,
                itemBuilder: ((context, index) {
                  int revIndex = snapshot.data['groups'].length - index -1;
                  return GroupTile(userName: snapshot.data['fullName'], groupId: getId(snapshot.data['groups'][revIndex]), groupName: getName(snapshot.data['groups'][revIndex]));
                })
              );
            }else{
              return noGroupWidget();
            }

          }else{
            return noGroupWidget();
          }
        }else{
          return Center(child: CircularProgressIndicator(color: GiveStyle().cta));
        }
      },
    );
  }

  noGroupWidget()
  {
    return Container
    (
      padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 20.w),
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: 
        [
          GestureDetector
          (
            onTap: () {
              showDialog(context: context, builder: (context)
              {
                return CallToActionCreateGroup(_isLoading);
              });
            },
            child: Center
            (
              child: SvgPicture.asset("assets/CreateRoom.svg",color: GiveStyle().secondary,)
            )
          ),
          SizedBox(height: 16.h,),
          Center(child: Text("Create Room",style: GiveStyle().normal())),
        ],
      )
    );
  }

  Dialog CallToActionCreateGroup(bool isLoading)
  {
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
          height: 180.h,
          child: Padding
          (
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                // isLoading == true ? Center(child: CircularProgressIndicator(color: GiveStyle().cta)):
                //Create a room
                Text("Create a room",style: GiveStyle().ctaHeading()),

                SizedBox(height: 8.h,),

                TextField
                (
                  
                  onChanged: (val)
                  {
                    setState(() {
                      groupName = val;
                      // print(groupName);
                    });
                  },

                  style: GiveStyle().inputText(),
                  decoration: InputDecoration
                  (
                    contentPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 10.w),
                    labelStyle: GiveStyle().labelText().copyWith(color: GiveStyle().secondary_70),
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
                  )
                ),

                SizedBox(height: 16.h,),

                Row
                (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: 
                  [
                    //Cancel Button
                    GestureDetector
                    (
                      onTap: (() {
                        // print("Tapped on Cancel Button");
                        Navigator.pop(context);
                      }),
                      child: Container
                      (
                        decoration: BoxDecoration
                        (
                          // color: GiveStyle().cta,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: GiveStyle().cta)
                    
                        ),
                        child: Padding 
                        (
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text("Cancel",style: GiveStyle().normal().copyWith(color: GiveStyle().cta,fontFamily: 'Product Sans Bold'),)
                          
                        ),
                      ),
                    ),

                    //Create Button
                    GestureDetector
                    (
                      onTap: (() async{
                        if(groupName.isNotEmpty)
                        {
                          setState((() => _isLoading = true));
                          // print("Done creating Group");
                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() => _isLoading = false);
                          Navigator.of(context).pop();
                          showSnackbar(context, Colors.green, "The group has been created");
                        }
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
                          child: Text("Create",style: GiveStyle().normal().copyWith(color: GiveStyle().dominant,fontFamily: 'Product Sans Bold'),)
                          
                        ),
                      ),
                    ),
                  ],
                )

                
              ],
            )
          ),
        )
    );
  }
}

// ignore: non_constant_identifier_names