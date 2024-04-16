import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seventh_project/Controller/history_controller.dart';
import 'package:seventh_project/Shared/Screen/otp_screen.dart';
import 'package:seventh_project/Shared/Widget/alert_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static Future signInWithGoogle(BuildContext context) async {
    try {
      SharedPreferences shared = await SharedPreferences.getInstance();
      GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      return await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        if (value.user != null) HistoryController.createUser(context);
        shared.setInt('signinTime', DateTime.now().millisecondsSinceEpoch);
      });
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
    } catch (e) {
      print(e);
    }
  }

  static Future sendOtp(BuildContext context, String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number')
            alert_widget('رقم الهاتف غير صحيح', Icons.error_outline, context);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Otp_screen(
                      phoneNumber: phoneNumber,
                      verificationId: verificationId)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> signInWithNum(
      BuildContext context, String verificationId, String sms) async {
    try {
      SharedPreferences shared = await SharedPreferences.getInstance();
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: sms);

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        if (value.user != null) {
          HistoryController.createUser(context);
          shared.setInt('signinTime', DateTime.now().millisecondsSinceEpoch);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future deleteAcoount(BuildContext context) async {
    try {
      SharedPreferences shared = await SharedPreferences.getInstance();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      // last user sign in
      DateTime lastDate =
          DateTime.fromMillisecondsSinceEpoch(shared.getInt('signinTime')!);
      // check If the time at which the recording was made is the same as the current time
      if (lastDate.hour == DateTime.now().hour) {
        FirebaseAuth.instance.currentUser!.delete();
      } else {
        alert_widget(
            'يرجي تسجيل الخروج واعادة تسجيل الدخول لكي تتمكن من حذف الحساب',
            Icons.error_outline,
            context);
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
    } catch (e) {
      print(e);
    }
  }
}
