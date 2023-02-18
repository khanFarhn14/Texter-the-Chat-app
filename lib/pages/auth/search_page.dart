import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/chat_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/textstyle.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchsnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined = false;

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

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async
  {
    await HelperFunctions.getUserNameFromSF().then((value)
    {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
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
          title: Text("Search Page",style: GiveStyle().inputText().copyWith(color: GiveStyle().secondary)),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
          child: Column
          (
            children: 
            [
              TextField
              (
                controller: searchController,
                style: GiveStyle().inputText(),

                //This below code will change the Action on phone keyboard
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  //Search Function will be here
                  initiateSearchMethod();
                  
                },

                decoration: InputDecoration
                (
                  hintText: 'Search groups...',
                  hintStyle: TextStyle(color: GiveStyle().secondary_70, fontFamily: 'Product Sans', fontSize: 12.sp),
                  // labelText: 'Search here...',
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 10.w),
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

              isLoading ? Center(child: Column(children: [SizedBox(height: 16.h,),CircularProgressIndicator(color: GiveStyle().cta)],)) : groupsList()
            ],
          ),
        )
      ),
    );
  }
  
  initiateSearchMethod() async
  {
    if(searchController.text.isNotEmpty)
    {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot)
      {
        setState(() {
          searchsnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }
  
  //GroupList Function
  groupsList() 
  {
    return hasUserSearched ? ListView.builder
    (
      shrinkWrap: true,
      itemCount: searchsnapshot!.docs.length,
      itemBuilder: (context, index) {
        return groupTile
        (
          userName, 
          searchsnapshot!.docs[index]['groupId'],
          searchsnapshot!.docs[index]['groupName'],
          searchsnapshot!.docs[index]['admin'],
          
        );
      },
    ) : Container();
  }

  joinedOrNot(String userName, String groupId, String groupName, String admin) async
  {
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined = value;
      });
    });
  }

  //groupTile Function
  Widget groupTile(String userName, String groupId, String groupName, String admin)
  {
    // A function to check whether the user is joined or not
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile
    (
      // visualDensity: VisualDensity(horizontal: -5, vertical: 0),
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
      leading: CircleAvatar
      (
        radius: 30,
        backgroundColor: GiveStyle().secondary,
        child: Text(groupName.substring(0,1).toUpperCase(), style: GiveStyle().pageHeading().copyWith(color: GiveStyle().dominant)),
      ),

      title: Text(groupName, style: TextStyle(color: GiveStyle().secondary, fontFamily: 'Product Sans Bold', fontSize: 16)),
      subtitle: Text("Admin: ${getName(admin)}", style: TextStyle(color: GiveStyle().secondary_70, fontFamily: 'Product Sans', fontSize: 12)),
      trailing: InkWell
      (
        onTap: (() async{
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
          if(isJoined)
          {
            setState(() {
              isJoined = !isJoined;
            });

            // ignore: use_build_context_synchronously
            showSnackbar(context, Colors.green.withOpacity(0.6), "Successfully joined the Room");
            Future.delayed(const Duration(seconds: 1),() 
            {
              nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            });
          }else{
            isJoined = !isJoined;
            // ignore: use_build_context_synchronously
            showSnackbar(context, Colors.red.withOpacity(0.6), "Exited from the Room");
          }
        }),
        child: isJoined ? Container
        (
          decoration: BoxDecoration
            (
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: GiveStyle().cta)
        
            ),
            child: Padding 
            (
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Text("Exit Room",style: TextStyle(color: GiveStyle().cta,fontFamily: 'Product Sans', fontSize: 12),)
            ),
          
        ): Container
        (
          decoration: BoxDecoration
          (
            color: GiveStyle().cta,
            borderRadius: BorderRadius.circular(30.r),
        
          ),
          child: Padding 
          (
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Text("Join Room",style: TextStyle(color: GiveStyle().dominant,fontFamily: 'Product Sans', fontSize: 12),)
            
          ),
        ),
      ),
    );
  }
}