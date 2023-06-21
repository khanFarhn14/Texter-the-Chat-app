import 'package:chat_app/pages/auth/group_info.dart';
import 'package:chat_app/pages/auth/message_tile.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../../widgets/textstyle.dart';
import '../../widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();  
  String admin = "";

  @override
  void initState()
  {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin()
  {
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats = val;
      });
    });

    DatabaseService().getGroupAdmin(widget.groupId).then((val){
      setState(() {
        admin = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser
    (
      gestures: const
      [
        GestureType.onTap,
        // GestureType.onVerticalDragDown,
      ],
      child: Theme
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
                onPressed:() => nextScreen(context, GroupInfo(adminName: admin, groupId: widget.groupId, groupName: widget.groupName,)),
                icon: const Icon(Icons.info),
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
            title: Text(widget.groupName,style: GiveStyle().inputText().copyWith(color: GiveStyle().secondary)),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
    
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Stack
            (
              children: 
              [
                chatMessage(),
                Container
                (
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: TextField
                  (
                    controller: messageController,
                    style: GiveStyle().inputText(),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      sendMessage();
                    },
    
                    decoration: InputDecoration
                    (
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: GiveStyle().secondary_70, fontFamily: 'Product Sans', fontSize: 12.sp),
    
                      contentPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
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
    
                      suffixIcon: InkWell
                      (
                        customBorder: const CircleBorder(),
                        splashColor: GiveStyle().cta.withOpacity(0.4),
                        onTap: (() {
                          sendMessage();
                        }),
                        child: Icon(Icons.send,color: GiveStyle().secondary,size: 20,)
                      ),
                    ) 
                  ),
                  
                )
              ],
            ),
          )
        ),
      ),
    );
  }
  
  chatMessage()
  {
    return StreamBuilder
    (
      stream: chats,
      builder: (context, AsyncSnapshot snapshot)
      {
        return snapshot.hasData ? ListView.builder
        (
          itemCount: snapshot.data.docs.length,
          itemBuilder: ((context, index) {
            return MessageTile(message: snapshot.data.docs[index]['message'], sender: snapshot.data.docs[index]['sender'], sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
          }),
        ): Container();
      },
    );
  }

  sendMessage() 
  {
    if(messageController.text.isNotEmpty)
    {
      Map<String, dynamic> chatMessageMap = 
      {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}