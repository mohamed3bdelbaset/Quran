import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seventh_project/Model/history_model.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class HistoryController {
  static Future createUser(BuildContext context) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User user = FirebaseAuth.instance.currentUser!;

      final ref = firestore.collection('users').doc(user.uid);
      ref.get().then((value) {
        if (!value.exists) showEditDialog(context);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future sendHistory(Map data) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User user = FirebaseAuth.instance.currentUser!;
      final ref =
          firestore.collection('users').doc(user.uid).collection('History');
      String id = UniqueKey().hashCode.toString();
      DocumentReference doc = ref.doc(id);
      doc.set(data);
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<HistoryModel>> historyStream() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser!;
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('History')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HistoryModel.fromJson(doc.data()))
            .toList());
  }

  static Future showEditDialog(BuildContext context) async {
    String gender = '';
    String age = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('إضافة معلوماتك الشخصية',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.LargeFont)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDropdown.search(
              hintText: 'العمر',
              items: [for (int i = 15; i < 80; i++) i],
              onChanged: (value) {
                age = value.toString();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CustomDropdown(
                hintText: 'النوع',
                items: ['ذكر', 'انثي'],
                onChanged: (value) {
                  gender = value.toString();
                },
              ),
            )
          ],
        ),
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  fixedSize:
                      Size(context.ScreenWidth / 3, context.ScreenHeight / 20)),
              onPressed: () {
                User user = FirebaseAuth.instance.currentUser!;
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                final ref = firestore.collection('users').doc(user.uid);
                final data = {
                  'Uid': user.uid,
                  'Created': DateTime.now().millisecondsSinceEpoch,
                  'Name': user.displayName ?? '',
                  'Phone': user.phoneNumber ?? '',
                  'Email': user.email ?? '',
                  'Age': age,
                  'Gender': gender
                };
                if (age != '' && gender != '') {
                  ref.set(data);
                  Navigator.pop(context);
                }
              },
              child: Text('إضافة',
                  style: TextStyle(fontSize: context.MiddleFont))),
          TextButton(
            style: TextButton.styleFrom(
                fixedSize:
                    Size(context.ScreenWidth / 3, context.ScreenHeight / 20)),
            onPressed: () {
              User user = FirebaseAuth.instance.currentUser!;
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              final ref = firestore.collection('users').doc(user.uid);
              final data = {
                'Uid': user.uid,
                'Created': DateTime.now().millisecondsSinceEpoch,
              };
              ref.set(data);
              Navigator.pop(context);
            },
            child: Text('تخطي', style: TextStyle(fontSize: context.MiddleFont)),
          )
        ],
      ),
    );
  }
}
