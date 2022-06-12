// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/views/dashboard/dashboard.dart';
import 'package:ferce_app/views/navigationBar/navigationBar.dart';
import 'package:ferce_app/views/widget/snackBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future registerUser(String email, String password, String username,
    String phoneNumber, context) async {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  try {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      final User? user = _firebaseAuth.currentUser;
      final uid = user?.uid;
      // print("Your current id is $uid");
      //store user data to firestore

      FirebaseFirestore.instance.collection("users").doc(uid).set({
        'fullName': '',
        'userName': username,
        'phonenumber': phoneNumber,
        'email': email,
        "userId": uid,
        'state': 'online',
        'avatar': "https://i.imgur.com/YtZkAbe.jpg",
        'background': 'https://i.imgur.com/fRjRPRc.jpg',
        'favoriteList': FieldValue.arrayUnion([]),
        'saveList': FieldValue.arrayUnion([]),
        'follow': FieldValue.arrayUnion([]),
        'role': 'Normal',
        'gender': '',
        'dob': ''
      }).then((signedInUser) => {
            print("successfully registered!"),
          });
      signIn(email, password, context);
    });
  } on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case "operation-not-allowed":
        showSnackBar(context, "Anonymous accounts are not enabled!", 'error');
        break;
      case "weak-password":
        showSnackBar(context, "Your password is too weak!", 'error');
        break;
      case "invalid-email":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;
      case "email-already-in-use":
        showSnackBar(context, "Email is used on different account!", 'error');
        break;
      case "invalid-credential":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;

      default:
        showSnackBar(context, "An undefined Error happened.", 'error');
    }
  }
}

// Sign-in
Future signIn(String email, String password, context) async {
  try {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      print("successfully login!");
      final User? user = auth.currentUser;
      final uid = user?.uid;
      // print("Your current id is $uid");
      if (uid != null) {
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => navigationBar(required, uid: uid)));
      }
    });
  } on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case "user-not-found":
        showSnackBar(
            context, "Your email is not found, please check!", 'error');
        break;
      case "wrong-password":
        showSnackBar(context, "Your password is wrong, please check!", 'error');
        break;
      case "invalid-email":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;
      case "user-disabled":
        showSnackBar(context, "The user account has been disabled!", 'error');
        break;
      case "too-many-requests":
        showSnackBar(
            context, "There was too many attempts to sign in!", 'error');
        break;
      case "operation-not-allowed":
        showSnackBar(context, "The user account are not enabled!", 'error');
        break;
      // // Preventing user from entering email already provided by other login method
      // case "account-exists-with-different-credential":
      //   showErrorSnackBar(context, "This account exists with a different sign in provider!");
      //   break;

      default:
        showSnackBar(context, "An undefined Error happened.", 'error');
    }
  }
}

//Sign-out
signOut() async {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  await _firebaseAuth.signOut();
}

  // //changePassword
  // static Future<void> changePassword(
  //     currentPassword, newPassword, context) async {
  //   final user = FirebaseAuth.instance.currentUser!;
  //   try {
  //     try {
  //       var authResult = await user.reauthenticateWithCredential(
  //         EmailAuthProvider.credential(
  //           email: (user.email).toString(),
  //           password: currentPassword,
  //         ),
  //       );
  //       user.updatePassword(newPassword).then((_) {
  //         // controlUpdateEncPw(newPassword);
  //         showSnackBar(context, 'Successfully changed password!', 'success');
  //         Navigator.pop(context);
  //       }).catchError((error) {
  //         showSnackBar(context, 'Your current password is wrong!', 'error');
  //       });
  //       return null;
  //     } on FirebaseAuthException {
  //       showSnackBar(context, 'Your current password is wrong!', 'error');
  //     }
  //   } on FirebaseAuthException {
  //     showSnackBar(context, 'Your current password is wrong!', 'error');
  //   }
  // }

