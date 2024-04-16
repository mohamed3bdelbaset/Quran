import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Model/ayah_model.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/surah_info.dart';
import 'package:seventh_project/States/quran_state.dart';

class TafsserView_widget extends StatefulWidget {
  const TafsserView_widget({super.key});

  @override
  State<TafsserView_widget> createState() => _TafsserView_widgetState();
}

class _TafsserView_widgetState extends State<TafsserView_widget> {
  int? greennumber;
  int? rednumber;
  int? bluenumber;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<quranController, QuranState>(
      builder: (context, state) {
        quranController quran = BlocProvider.of<quranController>(context);
        return ListView(
          padding: EdgeInsets.only(
              bottom: context.ScreenHeight / 15, left: 15, right: 15),
          children: [
            for (int i = 0; i < quran.ayahs.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (quran.ayahs[i].numberInSurah == 1)
                    surah(quran.ayahs[i], quran),
                  if (quran.ayahs[i].numberInSurah == 1 &&
                      quran.surahNumber != 9 &&
                      quran.surahNumber != 1)
                    Image.asset('assets/basmallah.png',
                        color: context.defaultColor,
                        width: context.ScreenWidth,
                        height: context.LargeFont * 2),
                  RichText(
                    text: TextSpan(
                      text: quran.ayahs[i].code_v2.replaceAll('\n', '') + ' ',
                      style: TextStyle(
                          height: 2,
                          letterSpacing: 5,
                          color: context.defaultColor,
                          fontSize: context.MiddleFont * 1.1,
                          fontFamily: 'page${quran.ayahs[i].page}'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    alignment: Alignment.centerRight,
                    child: Text(
                      quran.ayahs[i].tafsser,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: context.MiddleFont / 1.1),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      quran.ayahs[i].translation,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: context.MiddleFont / 1.1),
                    ),
                  )
                ],
              ),
          ],
        );
      },
    );
  }

  GestureDetector surah(Ayah model, quranController quran) {
    return GestureDetector(
      onLongPress: () {
        for (int i = 0; i < dates.surahs.length; i++) {
          if ((model.surahNumber ?? quran.surahNumber) ==
              dates.surahs[i].number) {
            quran.surahSelectNumber = dates.surahs[i].number;
            quran.surah = dates.surahs[quran.surahSelectNumber - 1];
          }
        }
        showDialog(context: context, builder: (context) => Surah_info());
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/Surah4.png',
                height: context.ScreenHeight / 18,
                width: context.ScreenWidth,
                fit: BoxFit.fill,
                color: context.isDark
                    ? Color(0xff806f57)
                    : Theme.of(context).hintColor),
            SvgPicture.asset(
              'assets/surah_name/00${model.surahNumber ?? quran.surahNumber}.svg',
              height: context.ScreenHeight / 33,
              colorFilter:
                  ColorFilter.mode(context.defaultColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
