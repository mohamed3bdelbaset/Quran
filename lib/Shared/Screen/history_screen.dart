import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:seventh_project/Controller/auth_controller.dart';
import 'package:seventh_project/Controller/history_controller.dart';
import 'package:seventh_project/Model/history_model.dart';
import 'package:seventh_project/Shared/Screen/phoneAuth_screen.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class History_screen extends StatefulWidget {
  const History_screen({super.key});

  @override
  State<History_screen> createState() => _History_screenState();
}

class _History_screenState extends State<History_screen> {
  bool historyEmpty = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          actions: [
            if (snapshot.hasData)
              PopupMenuButton(
                position: PopupMenuPosition.under,
                onSelected: (value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                  } else if (value == 'delete') {
                    deleteAccountDialog();
                  } else if (value == 'deleteHistory') {
                    deleteUserHistory();
                  }
                },
                itemBuilder: (context) => [
                  if (!historyEmpty)
                    PopupMenuItem(
                      value: 'deleteHistory',
                      child: Text('حذف السجل',
                          style: TextStyle(fontSize: context.MiddleFont)),
                    ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Text('تسجيل الخروج',
                        style: TextStyle(fontSize: context.MiddleFont)),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('حذف الحساب',
                        style: TextStyle(fontSize: context.MiddleFont)),
                  )
                ],
              )
          ],
        ),
        // check if user sign in or not
        body: snapshot.hasData ? historyWidget() : loginWidget(),
      ),
    );
  }

  Column loginWidget() {
    return Column(
      children: [
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                fixedSize:
                    Size(context.ScreenWidth / 1.5, context.ScreenHeight / 20),
                shape: RoundedRectangleBorder()),
            onPressed: () => AuthController.signInWithGoogle(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('تسجيل الدخول بواسطة جوجل',
                    style: TextStyle(
                        color: Colors.white, fontSize: context.MiddleFont)),
                Image.asset('assets/google.png', height: context.IconSize)
              ],
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
              fixedSize:
                  Size(context.ScreenWidth / 1.5, context.ScreenHeight / 20),
              shape: RoundedRectangleBorder()),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PhoneAuth_screen())),
          child: Text('تسجيل الدخول بواسطة الهاتف',
              style:
                  TextStyle(color: Colors.white, fontSize: context.MiddleFont)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
          child: Text(
              'يمكنك تسجيل الدخول لحفظ سجل الحفظ الخاص بك لتستيع معرفة مدي قوتك في الحفظ والتحسين منها',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.MiddleFont)),
        )
      ],
    );
  }

  StreamBuilder historyWidget() {
    return StreamBuilder<List<HistoryModel>>(
      stream: HistoryController.historyStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.data!.isNotEmpty) {
          historyEmpty = false;
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                // to jump to page continue this part
                String text = snapshot.data![index].pageDetail;
                int pageValue = int.parse(text
                    .substring(text.lastIndexOf('صفحة'), text.indexOf('جزء'))
                    .replaceAll('صفحة', '')
                    .trim());
                HomePageController.jumpToPage(pageValue - 1);
                Navigator.pop(context);
              },
              title: SvgPicture.asset(
                'assets/surah_name/00${snapshot.data![index].surah}.svg',
                height: 30,
                alignment: Alignment.centerRight,
                colorFilter:
                    ColorFilter.mode(context.defaultColor, BlendMode.srcIn),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(' الايات ' + snapshot.data![index].ayahs,
                      style: TextStyle(fontSize: context.SmallFont)),
                  Text(
                      DateFormat.MMMMEEEEd('ar').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data![index].day)),
                      style: TextStyle(fontSize: context.SmallFont))
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.data![index].pageDetail.replaceFarsi,
                      style: TextStyle(fontSize: context.MiddleFont)),
                  Text(
                      'الوقت المستغرق: ' +
                          snapshot.data![index].timeTaken.replaceFarsi,
                      style: TextStyle(fontSize: context.MiddleFont))
                ],
              ),
            ),
            separatorBuilder: (context, index) =>
                Divider(endIndent: 25, indent: 25),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/emptyList.json',
                  alignment: Alignment.center, fit: BoxFit.contain),
              Center(
                child: Text(
                    'لا يوجد سجلات حفظ حاليا عندما يوجد سجلات سوف تظهر هنا',
                    style: TextStyle(fontSize: context.MiddleFont * 1.1)),
              )
            ],
          );
        }
      },
    );
  }

  void deleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('هل أنت متأكد أنك تريد حذف الحساب !؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.LargeFont)),
        content: Text('سيؤدي حذف الحساب الي حذف سجلات الحفظ ايصا',
            style: TextStyle(fontSize: context.MiddleFont)),
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                fixedSize:
                    Size(context.ScreenWidth / 3, context.ScreenHeight / 20)),
            onPressed: () => AuthController.deleteAcoount(context),
            child: Text('حذف', style: TextStyle(fontSize: context.MiddleFont)),
          ),
          TextButton(
            style: TextButton.styleFrom(
                fixedSize:
                    Size(context.ScreenWidth / 3, context.ScreenHeight / 20)),
            onPressed: () => Navigator.pop(context),
            child: Text('لا', style: TextStyle(fontSize: context.MiddleFont)),
          )
        ],
      ),
    );
  }

  void deleteUserHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('هل أنت متأكدأنك تريد السجل !؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.LargeFont)),
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                fixedSize:
                    Size(context.ScreenWidth / 3, context.ScreenHeight / 20)),
            onPressed: () async {
              final instance = FirebaseFirestore.instance;
              final user = FirebaseAuth.instance.currentUser;
              final batch = instance.batch();
              var collection = instance
                  .collection('users')
                  .doc(user!.uid)
                  .collection('History');
              var snapshots = await collection.get();
              for (var doc in snapshots.docs) {
                batch.delete(doc.reference);
              }
              await batch.commit();
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(fontSize: context.MiddleFont)),
          ),
          TextButton(
            style: TextButton.styleFrom(
                fixedSize:
                    Size(context.ScreenWidth / 3, context.ScreenHeight / 20)),
            onPressed: () => Navigator.pop(context),
            child: Text('لا', style: TextStyle(fontSize: context.MiddleFont)),
          )
        ],
      ),
    );
  }
}
