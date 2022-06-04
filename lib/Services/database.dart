import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  Future addMessage(
      String chatRoomId, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageInfoMap);
  }

  Stream<QuerySnapshot> getChatRoomMessages(chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
<<<<<<< HEAD
        .orderBy("ts")
=======
        .orderBy("ts", descending: false)
>>>>>>> ab42009eebeb719801c1c60e2864f4222fb5b12c
        .snapshots();
  }


  //create chatting session between two people if they havent chatted before
  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  //updates the last message sent in firebase
  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  //get all the people the user has chatted with
  Stream<QuerySnapshot> getChatRooms() {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("ts", descending: true)
        .where("users", arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future acceptRequest(String sellerId, String docId, String buyerId) async {
    List<String> meeters = [sellerId, buyerId];
    await FirebaseFirestore.instance
        .collection("requests")
        .doc(sellerId)
        .collection('request')
        .doc(docId)
        .update({
      "read": false,
      'meeters': meeters,
      "accepted": true,
      "acceptedBy": FirebaseAuth.instance.currentUser!.uid,
      "modified": false,
      "ts": DateTime.now()
    });
  }

  Future cancelRequest(String sellerId, String docId) async {
    List<String> meeters = [];
    await FirebaseFirestore.instance
        .collection("requests")
        .doc(sellerId)
        .collection('request')
        .doc(docId)
        .update({
      "read": false,
      'meeters': meeters,
      "accepted": false,
      "declinedBy": FirebaseAuth.instance.currentUser!.uid,
      "modified": false,
      "ts": DateTime.now()
    });
  }
}
