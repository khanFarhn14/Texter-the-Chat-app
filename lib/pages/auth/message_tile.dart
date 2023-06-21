import 'package:chat_app/widgets/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTile({super.key, required this.message, required this.sender, required this.sentByMe});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container
    (
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container
      (
        margin: widget.sentByMe ? const EdgeInsets.only(left: 40): const EdgeInsets.only(right: 40),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration
        (
          //Color
          color: widget.sentByMe ? GiveStyle().dominant: GiveStyle().secondary_20,
    
          //BorderRadius
          borderRadius: widget.sentByMe ? const BorderRadius.only
          (
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ) 
          :
          const BorderRadius.only
          (
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
    
          //Border Color
          border: widget.sentByMe ? Border.all(color: GiveStyle().secondary) : Border.all(color: GiveStyle().dominant) 
    
        ),
        child: widget.sentByMe ? Text(widget.message, style: GiveStyle().normal(),):Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            Text(widget.sender.toUpperCase(), style: TextStyle(color: GiveStyle().secondary, fontFamily: 'Product Sans', fontSize: 10, letterSpacing: 4)),
            SizedBox(height: 8.h,),
            Text(widget.message, style: GiveStyle().normal(),)
          ],
        )
      ),
    );
  }
}