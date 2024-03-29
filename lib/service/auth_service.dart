import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService
{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(String email, String password) async
  {
    try
    {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      return true;
    }on FirebaseAuthException catch (e){
      return e.message;
    }
  }


  //register
  Future registerUserWithEmailandPassword(String fullName, String email, String password) async
  {
    try
    {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
    }on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  //signout
  Future signOut() async
  {
    try{
      //Changing the value in SharedPreference
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      
      //Signint out
      await firebaseAuth.signOut();

    }catch (e){
      return null;
    }
  }
}