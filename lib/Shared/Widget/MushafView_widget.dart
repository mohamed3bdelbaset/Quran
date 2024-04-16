import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/custom_span.dart';
import 'package:seventh_project/Shared/Widget/surah_info.dart';

class MushafView_widget extends StatefulWidget {
  const MushafView_widget({super.key});

  @override
  State<MushafView_widget> createState() => _MushafView_widgetState();
}

class _MushafView_widgetState extends State<MushafView_widget> {
  bool before = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: context.orientation == Orientation.landscape
          ? SingleChildScrollView(
              physics: ClampingScrollPhysics(), child: mushaf_widget())
          : mushaf_widget(),
    );
  }

  TextSpan ayahTextView_widget(int i, int pageIndex) {
    quranController quran = BlocProvider.of<quranController>(context);
    String code = i == 0
        ? '${quran.ayahs[i].code_v2[0]}${quran.ayahs[i].code_v2.substring(1)}'
        : quran.ayahs[i].code_v2;
    // if surahNameBar show in anthor page
    bool after = quran.surahsStartBefore().contains(quran.page - 1);
    before = quran.surahsStartBefore().contains(quran.page) &&
        quran.ayahs.last.number == quran.ayahs[i].number;
    if (quran.surahName == 'سُورَةُ ٱلْفَاتِحَةِ' && i == 0) {
      return TextSpan(
        children: [
          surahNameBar(),
          TextSpan(text: '\n'),
          basmallah(pageIndex, i, faatiha: true),
        ],
      );
    } else if (quran.ayahs[i].numberInSurah == 1) {
      return TextSpan(
        children: [
          if (!after && quran.lastAyah(quran.ayahs[i].number - 1))
            TextSpan(text: '\n'),
          if (!after)
            quran.ayahs[i].surahNumber != null
                ? surahNameBar(number: quran.ayahs[i].surahNumber!)
                : surahNameBar(),
          if (!after && quran.ayahs[i].number != 1236) TextSpan(text: '\n'),
          // for surah At-Tawba
          if (quran.ayahs[i].number != 1236) basmallah(pageIndex, i),
          span(
            text: '\n' + code,
            pageIndex: pageIndex,
            backgroundColor: backgroundColor(quran.ayahs[i].number),
            isFirstAyah: i == 0,
            onLongPressStart: (p0) => onLongPressStart(i, longPress: true),
            onLongPressDown: (p0) => onLongPressStart(i),
            ayahColor: Theme.of(context).hintColor,
            textColor: selectedItemColor(i),
          ),
        ],
      );
    } else if (before) {
      return TextSpan(
        children: [
          span(
            text: code,
            pageIndex: pageIndex,
            isFirstAyah: i == 0,
            backgroundColor: backgroundColor(quran.ayahs[i].number),
            onLongPressStart: (p0) => onLongPressStart(i, longPress: true),
            onLongPressDown: (p0) => onLongPressStart(i),
            ayahColor: Theme.of(context).hintColor,
            textColor: selectedItemColor(i),
          ),
          TextSpan(text: '\n'),
          surahNameBar(),
        ],
      );
    } else {
      return span(
        text: code,
        pageIndex: pageIndex,
        isFirstAyah: i == 0,
        backgroundColor: backgroundColor(quran.ayahs[i].number),
        textColor: selectedItemColor(i),
        onLongPressStart: (p0) => onLongPressStart(i, longPress: true),
        onLongPressDown: (p0) => onLongPressStart(i),
        ayahColor: Theme.of(context).hintColor,
        // lastCharacterSpan: ayah(i),
      );
    }
  }

  WidgetSpan surahNameBar({int number = 0}) {
    quranController quran = BlocProvider.of<quranController>(context);
    number = before
        ? quran.numberisbefore
        : number != 0
            ? number
            : quran.surahNumber;
    return WidgetSpan(
      child: GestureDetector(
        onLongPress: () {
          for (int i = 0; i < dates.surahs.length; i++) {
            if (number == dates.surahs[i].number) {
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
                  height: 200,
                  fit: BoxFit.fill,
                  color: context.isDark
                      ? Color(0xff806f57)
                      : Theme.of(context).hintColor),
              SvgPicture.asset(
                'assets/surah_name/00$number.svg',
                height: 130,
                colorFilter:
                    ColorFilter.mode(context.defaultColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan basmallah(int pageIndex, int i, {bool faatiha = false}) {
    quranController quran = BlocProvider.of<quranController>(context);
    int number = quran.ayahs[i].number;
    return span(
      text: faatiha ? 'ﱁﱂﱃﱄﱅ' : 'ﱁﱂﱃﱄﱅ'.substring(0, 'ﱁﱂﱃﱄﱅ'.length - 1),
      pageIndex: 0,
      backgroundColor: faatiha ? backgroundColor(number) : Colors.transparent,
      isFirstAyah: true,
      onLongPressStart: (p0) =>
          faatiha ? onLongPressStart(i, longPress: true) : null,
      ayahColor: faatiha ? Theme.of(context).hintColor : context.defaultColor,
      textColor: context.defaultColor,
    );
  }

  FittedBox mushaf_widget() {
    quranController quran = BlocProvider.of<quranController>(context);
    return FittedBox(
      fit: BoxFit.fill,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
              color: context.defaultColor,
              fontSize: 100,
              letterSpacing: 2,
              fontFamily: 'page${quran.page}'),
          children: [
            for (int i = 0; i < quran.ayahs.length; i++)
              ayahTextView_widget(i, quran.page - 1)
          ],
        ),
      ),
    );
  }

  void onLongPressStart(int i, {bool longPress = false}) {
    quranController quran = BlocProvider.of<quranController>(context);
    int number = quran.ayahs[i].number;
    int numberInSurah = quran.ayahs[i].numberInSurah;
    // first tap as long press
    if (itemsPositionList.isEmpty && longPress) {
      itemsPositionList.add(number);
      itemsPositionListinSurah.add(numberInSurah);
      showStartButton = true;
    } else if (itemsPositionList.isNotEmpty &&
        (itemsPositionList.length < 6 && number > itemsPositionList.last)) {
      itemsPositionList.add(number);
      itemsPositionListinSurah.add(numberInSurah);
      showStartButton = true;
    }
    // get from and to ayah number by item list
    getFromAndToPosition(number);
  }

  void getFromAndToPosition(int i) {
    // handel list position to get first and last ayah selected
    if (itemsPositionList.length == 1) {
      fromVerseSelect = itemsPositionList[0];
      toVerseSelect = itemsPositionList[0];
    } else if (itemsPositionList.length > 1) if (itemsPositionList[0] < i &&
        i <= itemsPositionList[1]) {
      fromVerseSelect = itemsPositionList[0];
      toVerseSelect = handelPosition(i);
    } else if (itemsPositionList.length > 2 &&
        itemsPositionList[1] <= i &&
        i <= itemsPositionList[2]) {
      fromVerseSelect = itemsPositionList[1] + 1;
      toVerseSelect = handelPosition(i);
    } else if (itemsPositionList.length > 3 &&
        itemsPositionList[2] <= i &&
        i <= itemsPositionList[3]) {
      fromVerseSelect = itemsPositionList[2] + 1;
      toVerseSelect = handelPosition(i);
    } else if (itemsPositionList.length > 4 &&
        itemsPositionList[3] <= i &&
        i <= itemsPositionList[4]) {
      fromVerseSelect = itemsPositionList[3] + 1;
      toVerseSelect = handelPosition(i);
    } else if (itemsPositionList.length > 5 &&
        itemsPositionList[4] <= i &&
        i <= itemsPositionList[5]) {
      fromVerseSelect = itemsPositionList[4] + 1;
      toVerseSelect = handelPosition(i);
    }
    if (fromVerseSelect > toVerseSelect) fromVerseSelect = toVerseSelect;
  }

  Color backgroundColor(int number) {
    // Sections color according to the location of the section
    if (itemsPositionList.length > 0 && number == itemsPositionList[0]) {
      if (context.isDark)
        return Color(0xff9c4246);
      else
        return Colors.red.shade100;
    } else if (itemsPositionList.length > 1 &&
        number >= itemsPositionList[0] &&
        number <= itemsPositionList[1]) {
      if (context.isDark)
        return Color(0xff9c4246);
      else
        return Colors.red.shade100;
    } else if (itemsPositionList.length > 2 &&
        number > itemsPositionList[1] &&
        number <= itemsPositionList[2]) {
      if (context.isDark)
        return Color(0xff336b5f);
      else
        return Colors.green.shade100;
    } else if (itemsPositionList.length > 3 &&
        number > itemsPositionList[2] &&
        number <= itemsPositionList[3]) {
      if (context.isDark)
        return Color(0xff966c10);
      else
        return Colors.amber.shade100;
    } else if (itemsPositionList.length > 4 &&
        number > itemsPositionList[3] &&
        number <= itemsPositionList[4]) {
      if (context.isDark)
        return Color(0xff213945);
      else
        return Colors.blue.shade100;
    } else if (itemsPositionList.length > 5 &&
        number > itemsPositionList[4] &&
        number <= itemsPositionList[5]) {
      if (context.isDark)
        return Colors.brown;
      else
        return Colors.brown.shade100;
    } else if (itemsPositionList.length > 6 &&
        number <= itemsPositionList.last) {
      if (context.isDark)
        return Color(0xff213945);
      else
        return Colors.blue.shade100;
    } else {
      return Colors.transparent;
    }
  }

  int handelPosition(int number) {
    // get last ayah number by item list
    if (number <= itemsPositionList[1] && number >= itemsPositionList[0]) {
      return itemsPositionList[1];
    } else if (number >= itemsPositionList[1] &&
        number <= itemsPositionList[2]) {
      return itemsPositionList[2];
    } else if (number >= itemsPositionList[2] &&
        number <= itemsPositionList[3]) {
      return itemsPositionList[3];
    } else if (number >= itemsPositionList[3] &&
        number <= itemsPositionList[4]) {
      return itemsPositionList[4];
    } else {
      return itemsPositionList[5];
    }
  }

  Color selectedItemColor(int i) {
    // chech section selected if selected show text
    quranController quran = BlocProvider.of<quranController>(context);
    return (toVerseSelect == 0 ||
                (fromVerseSelect <= quran.ayahs[i].number &&
                    toVerseSelect >= quran.ayahs[i].number)) ||
            !showTimer
        ? context.defaultColor
        : Colors.transparent;
  }
}
