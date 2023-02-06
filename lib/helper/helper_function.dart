import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions
{
  //Keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //Saving the data to Shared Preferences
  //Logged in Status
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  //Saving UserName
  static Future<bool> saveUserNameSF(String userName) async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  //Saving User Email
  static Future<bool> saveUserEmailSF(String userEmail) async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }


  //Getting the data from Shared Preferences
  static Future<bool?> getUserLoggedInStatus() async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  //Getting User Email
  static Future<String?> getUserEmailFromSF() async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  //Getting User Name
  static Future<String?> getUserNameFromSF() async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}