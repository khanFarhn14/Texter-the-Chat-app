import 'package:chat_app/pages/auth/chat_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'textstyle.dart';

class GroupTile extends StatefulWidget {

  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({super.key, required this.userName, required this.groupId, required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector
    (
      onTap: () => nextScreen(context, ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,)),
      child: Container
      (
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 0),
        child: ListTile
        (
          leading: CircleAvatar
          (
            radius: 30,
            backgroundColor: GiveStyle().secondary,
            child: Text(widget.groupName.substring(0,1),style: GiveStyle().pageHeading().copyWith(color: GiveStyle().dominant)),
          ),
          title: Text(widget.groupName,style: TextStyle(color: GiveStyle().secondary, fontFamily: 'Product Sans Bold', fontSize: 20)),
          subtitle: Text("Join Conversation ${widget.userName}",style: TextStyle(color: GiveStyle().secondary_70, fontFamily: 'Product Sans', fontSize: 12)),
        ),
      ),
    );
  }
}