import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:share_plus/share_plus.dart';

class Surah_info extends StatefulWidget {
  const Surah_info({super.key});

  @override
  State<Surah_info> createState() => _Surah_infoState();
}

class _Surah_infoState extends State<Surah_info> {
  @override
  Widget build(BuildContext context) {
    quranController quran = BlocProvider.of<quranController>(context);
    String surahData =
        'صفحة ${quran.surah.ayahs.first.page}  إيات ${quran.surah.ayahs.length}  ${quran.surah.revelationType}'
            .tr;
    String surahName = quran.surah.name;
    String surahThemes = quran.surah.themes;
    String surahCalled = '${quran.surah.called}';
    String SurahNumber = '${quran.surah.number}';
    return AlertDialog(
      elevation: 0.0,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(
          horizontal: context.ScreenWidth / 15,
          vertical: context.ScreenHeight / 3.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      iconPadding: EdgeInsets.only(left: 15, right: 15),
      icon: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
            onPressed: () async {
              await Share.share(
                  '$surahName\n$surahData \n\nمن مقاصد السورة\n$surahThemes ${surahCalled != 'null' ? '\n\nسبب التسمية\n$surahCalled' : ''}');
            },
            icon: Icon(Icons.ios_share_rounded, size: context.IconSize / 1.1)),
      ),
      content: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).focusColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: ListTile(
                  title: Text(surahName,
                      style: TextStyle(fontSize: context.LargeFont / 1.1)),
                  subtitle: Text(surahData,
                      style: TextStyle(fontSize: context.MiddleFont)),
                  leading: Container(
                    height: context.ScreenWidth / 10,
                    width: context.ScreenWidth / 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        shape: BoxShape.circle),
                    child: Text(
                      SurahNumber,
                      style: TextStyle(fontSize: context.MiddleFont),
                    ),
                  ),
                ),
              ),
              Text('       من مقاصد السورة',
                  style: TextStyle(fontSize: context.MiddleFont / 1.1)),
              Container(
                width: context.ScreenWidth,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(color: Theme.of(context).focusColor),
                child: Text(surahThemes,
                    style: TextStyle(fontSize: context.MiddleFont)),
              ),
              if (quran.surah.called != null)
                Text('       سبب التسمية',
                    style: TextStyle(fontSize: context.MiddleFont / 1.1)),
              if (quran.surah.called != null)
                Container(
                  width: context.ScreenWidth,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration:
                      BoxDecoration(color: Theme.of(context).focusColor),
                  child: Text(surahCalled,
                      style: TextStyle(fontSize: context.MiddleFont)),
                )
            ],
          ),
        ),
      ),
    );
  }
}
