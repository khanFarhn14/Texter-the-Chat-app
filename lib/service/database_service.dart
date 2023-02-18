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

  //Get User Groups
  getUserGroups() async
  {
    return userCollection.doc(uid).snapshots();
  }

  //Creating a group
  Future createGroup(String userName, String id, String groupName) async 
  {
    DocumentReference groupDocumentReference = await groupCollection.add(
      {
        "groupName": groupName,
        "groupIcon": "",
        "admin": "${id}_$userName",
        "members": [],
        "groupId": "",
        "recentMessage": "",
        "recentMessageSender": ""
      }
    );

    //Update the members
    await groupDocumentReference.update(
      {
        "members": FieldValue.arrayUnion(["${uid}_$userName"]),
        "groupId": groupDocumentReference.id,
      }
    );

    //
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update(
      {
        "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])    
      }
    );
  }

  //Getting the chats
  getChats(String groupId) async{
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }

  Future getGroupAdmin(String groupId) async
  {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //Get Group Members
  getGroupMembers(groupId) async
  {
    return groupCollection.doc(groupId).snapshots();
  }

  //Search Groups
  searchByName(String groupName)
  {
    return groupCollection.where("groupName",isEqualTo: groupName).get();
  }

  //Has user joind the Group or not
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async
  {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName"))
    {
      return true;
    }else{
      return false;
    }
  }

  //Toggling the Group join or Exit
  Future toggleGroupJoin(String groupId, String userName, String groupName) async
  {
    //doc Reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    //If user has Joined the group then logout or Join them
    if(groups.contains("${groupId}_$groupName"))
    {
      await userDocumentReference.update(
        {
          "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
        }
      );

      await groupDocumentReference.update(
        {
          "members": FieldValue.arrayRemove(["${uid}_$userName"])
        }
      );
    }else{
      await userDocumentReference.update(
        {
          "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
        }
      );

      await groupDocumentReference.update(
        {
          "members": FieldValue.arrayUnion(["${uid}_$userName"])
        }
      );
    }
  }

  //Send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async
  {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString()
    });
  }
}