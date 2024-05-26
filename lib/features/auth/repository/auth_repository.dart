import 'dart:developer';
import 'dart:io';
import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authrepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    firebaseStorage: FirebaseStorage.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.firebaseStorage,
  });
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? userModel;
    if (userData.data() != null) {
      userModel = UserModel.fromMap(userData.data()!);
    }
    return userModel;
  }

  void registerUser({required String email, required String password}) async {
    try {
      auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }

  void loginUser({required String email, required String password}) async {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }

  void signOut(BuildContext context) async {
    try {
      auth.signOut();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }

  void saveUserData({
    required String name,
    required String email,
    required File profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      UploadTask uploadTask =
          firebaseStorage.ref().child('profilePic/$uid').putFile(profilePic);
      String downloadTask = await (await uploadTask).ref.getDownloadURL();
      photoUrl = downloadTask;
      var user = UserModel(
        name: name,
        profilePic: photoUrl,
        uid: uid,
        email: email,
        wallet: 0,
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }
}
