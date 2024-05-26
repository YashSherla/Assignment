import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/chats/model/chat_model.dart';
import 'package:assignment/features/chats/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  return ChatRepository(
    auth: auth,
    firestore: firestore,
  );
});

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({
    required this.auth,
    required this.firestore,
  });

  void _saveDataToContactsSubcollection({
    required String recieverUserId,
    required UserModel recieverUserData,
    required UserModel senderUserData,
    required String message,
    required DateTime timeSent,
  }) async {
    try {
      var recieverChatContact = ChatContact(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          lastMessage: message,
          timeSent: timeSent);

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(recieverChatContact.toMap());

      var senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        lastMessage: message,
        timeSent: timeSent,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(senderChatContact.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<UserModel>> allContactList() async {
    List<UserModel> alluserData = [];
    try {
      await firestore.collection('users').get().then((value) {
        for (var element in value.docs) {
          var data = UserModel.fromMap(element.data());
          alluserData.add(
            UserModel(
              name: data.name,
              profilePic: data.profilePic,
              uid: data.uid,
              email: data.email,
              wallet: data.wallet,
            ),
          );
        }
      });
      log(alluserData.toString());
    } catch (e) {
      log(e.toString());
    }
    return alluserData;
  }

  void _saveMessageToMessageSubcollection({
    required String receiverId,
    required DateTime timeSent,
    required String messageId,
    required String text,
    required String recevierusername,
    required String sendername,
  }) async {
    try {
      var message = Message(
          senderId: auth.currentUser!.uid,
          receiverId: receiverId,
          timeSent: timeSent,
          messageId: messageId,
          text: text);

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
      await firestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void sendMessage({
    required String receiverId,
    required String text,
    required UserModel senderData,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var data = await firestore.collection('users').doc(receiverId).get();
      recieverUserData = UserModel.fromMap(data.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactsSubcollection(
          recieverUserId: receiverId,
          recieverUserData: recieverUserData,
          senderUserData: senderData,
          message: text,
          timeSent: timeSent);
      _saveMessageToMessageSubcollection(
          receiverId: receiverId,
          timeSent: timeSent,
          messageId: messageId,
          text: text,
          recevierusername: recieverUserData.name,
          sendername: senderData.name);
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Message>> getMessage({required String recieverUserId}) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var doc in event.docs) {
        messages.add(Message.fromMap(doc.data()));
      }
      return messages;
    });
  }

  Stream<List<ChatContact?>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('chats')
        .snapshots()
        .map((event) {
      List<ChatContact?> contacts = [];
      if (event.docs.isEmpty) {
        return contacts;
      } else {
        for (var doc in event.docs) {
          contacts.add(ChatContact.fromMap(doc.data()));
        }
        return contacts;
      }
    });
  }
}
