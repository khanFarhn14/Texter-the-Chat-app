import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService
{
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  //The Below code will create a collection named users
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  //The Below code will create a collection named groups
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  //Saving the userdata
  Future savingUserData(String fullName, String email) async
  {
    return await userCollection.doc(uid).set
    (
      {
        "fullName": fullName,
        "email": email,
        "groups": [],
        "profilePic": "",
        "uid": uid,
      }
    );
  }

  //Getting User data
  Future gettinUserData(String email) async
  {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}