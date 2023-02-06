import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiveStyle
{
  final dominantDark = const Color(0xff011416);
  final dominant = const Color(0xff1B2223);
  final dominant_50 = const Color(0xff1B2223).withOpacity(0.5);
  final dominantLow = const Color(0xff3A4F50);
  final secondary = const Color(0xffF4FEFD);
  final secondary_70 = const Color(0xffF4FEFD).withOpacity(0.7);
  final secondary_50 = const Color(0xffF4FEFD).withOpacity(0.5);
  final secondary_20 = const Color(0xffF4FEFD).withOpacity(0.2);
  final cta = const Color(0xff16BD9F);


  //Page Intro
  TextStyle pageIntro()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Bold',
      fontSize: 24.sp,
      color: secondary,
    );
  }

  //Page Heading
  TextStyle pageHeading()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Bold',
      fontSize: 20.sp,
      color: secondary,
    );
  }

  //Page Heading
  TextStyle pageHeadingDescription()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Regular',
      fontSize: 12.sp,
      color: secondary_70,
    );
  }

  //normal
  TextStyle normal()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Regular',
      fontSize: 16.sp,
      color: secondary,
    );
  }

  //normal
  TextStyle labelText()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Regular',
      fontSize: 12,
      color: secondary_70,
    );
  }

  //normal
  TextStyle inputText()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Regular',
      fontSize: 16.sp,
      color: secondary_70,
    );
  }

  //CTA heading
  TextStyle ctaHeading()
  {
    return TextStyle
    (
      fontFamily: 'Product Sans Regular',
      fontSize: 24.sp,
      color: secondary,
    );
  }
}