import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/textstyle.dart';
import '../../widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({super.key, required this.groupId, required this.groupName, required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  //Getting user Name
  String getName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }

  @override
  void initState()
  {
    getMembers();
    super.initState();
  }

  //Getting Members
  getMembers() async
  {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupId).then((val){
      setState(() {
        members = val;
      });
    });
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
              onPressed: () async{
                showDialog(context: context, builder: (context)
                {
                  return CallToActionExitRoom(adminName: getName(widget.adminName), groupId: widget.groupId, groupName: widget.groupName,);
                });
              },
              icon: const Icon(Icons.exit_to_app),
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
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Column
          (
            children: 
            [
              SizedBox(height: 12.h,),
              Center(child: Text(widget.groupName, style: GiveStyle().pageHeading())),

              //Admin Row
              Container
              (
                decoration: BoxDecoration
                (
                  border: Border
                  (
                    bottom: BorderSide(width: 2.5, color: GiveStyle().secondary_50)
                  ),
                ),
                child: Padding
                (
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: 
                    [
                      Text(getName(widget.adminName),style: GiveStyle().normal(),),
                      Container
                      (
                        decoration: BoxDecoration
                        (
                          color: GiveStyle().secondary_20,
                          border: Border.all(color: GiveStyle().cta),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Padding
                        (
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Admin", style: TextStyle(color: GiveStyle().cta,fontFamily: 'Product Sans', fontSize: 12.sp)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              memberList(),
            ],
          ),
        )
      ),
    );
  }

  memberList()
  {
    return StreamBuilder
    (
      stream: members,
      builder: (context, AsyncSnapshot snapshot)
      {
        if(snapshot.hasData)
        {
          if(snapshot.data['members'] != null)
          {
            if(snapshot.data['members'].length != 0)
            {
              return ListView.builder
              (
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return Container
                  (
                    //Bottom Border
                    decoration: BoxDecoration
                    (
                      border: Border
                      (
                        bottom: BorderSide(width: 2.5, color: GiveStyle().secondary_50)
                      ),
                    ),

                    child: Padding
                    ( 
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Row
                      (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: 
                        [
                          Text(getName(snapshot.data['members'][index]),style: GiveStyle().normal(),),
                          Padding
                          (
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Members", style: TextStyle(color: GiveStyle().secondary,fontFamily: 'Product Sans', fontSize: 12.sp)),
                          )
                        ],
                      ),
                    )
                  );
                })
              );
            }else{
              return const Center(child: Text("NO MEMBERS"));
 
            }
          }else{
            return const Center(child: Text("NO MEMBERS"));
          }
        }else{
          return Center(child: CircularProgressIndicator(color: GiveStyle().cta));
        }
      }
    );
  }
}