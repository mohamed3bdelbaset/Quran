library config.globals;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Model/reciter_model.dart';
import 'package:seventh_project/Shared/Widget/responsive_widget.dart';

// The first verse number selected in the playlist is based on the position in the Quran
int fromVerseSelect = 0;
// The last verse number selected in the playlist is based on the position in the Quran
int toVerseSelect = 0;
// list is contain first and last positions in playlist
List<int> itemsPositionList = [];
List<int> itemsPositionListinSurah = [];
bool showTimer = false;
bool showStartButton = false;
// show search and reciter icon
bool showMore = false;
// show tafsser mode
bool showTafsser = false;
AudioPlayer ayahPlayer = AudioPlayer();

Reciter_model cacheReciter = dates.reciter[0];

late Duration ReadDuration;

extension BuildContextHelper on BuildContext {
  double get ScreenHeight => MediaQuery.of(this).size.height;
  double get ScreenWidth => MediaQuery.of(this).size.width;

  double get LargeFont => largetext(MediaQuery.of(this).size.height);
  double get MiddleFont => middletext(MediaQuery.of(this).size.height);
  double get SmallFont => smalltext(MediaQuery.of(this).size.height);
  double get IconSize => iconSize(MediaQuery.of(this).size.height);

  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;
  Color get defaultColor => Theme.of(this).textTheme.titleLarge!.color!;

  Orientation get orientation => MediaQuery.of(this).orientation;
}

extension StringHelper on String {
  String get tr =>
      this.replaceAll('Medinan', 'مدنية').replaceAll('Meccan', 'مكية');
  // to convert number from english to arabic number
  String get replaceFarsi {
    String data = this;
    const english = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'Meccan',
      'Medinan',
      'AM',
      'PM'
    ];
    const farsi = [
      '۰',
      '۱',
      '۲',
      '۳',
      '٤',
      '۵',
      '٦',
      '۷',
      '۸',
      '۹',
      'مكية',
      'مدنية',
      'صَبَاحًا',
      'مَسَاءٌ'
    ];

    for (int i = 0; i < english.length; i++) {
      data = data.replaceAll(english[i], farsi[i]);
    }

    return data;
  }

// remove Formation arabic letters
  String get normalise => this
      .replaceAll('\u0610', '') //ARABIC SIGN SALLALLAHOU ALAYHE WA SALLAM
      .replaceAll('\u0611', '') //ARABIC SIGN ALAYHE ASSALLAM
      .replaceAll('\u0612', '') //ARABIC SIGN RAHMATULLAH ALAYHE
      .replaceAll('\u0613', '') //ARABIC SIGN RADI ALLAHOU ANHU
      .replaceAll('\u0614', '') //ARABIC SIGN TAKHALLUS

      //Remove koranic anotation
      .replaceAll('\u0615', '') //ARABIC SMALL HIGH TAH
      .replaceAll(
          '\u0616', '') //ARABIC SMALL HIGH LIGATURE ALEF WITH LAM WITH YEH
      .replaceAll('\u0617', '') //ARABIC SMALL HIGH ZAIN
      .replaceAll('\u0618', '') //ARABIC SMALL FATHA
      .replaceAll('\u0619', '') //ARABIC SMALL DAMMA
      .replaceAll('\u061A', '') //ARABIC SMALL KASRA
      .replaceAll('\u06D6',
          '') //ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA
      .replaceAll('\u06D7',
          '') //ARABIC SMALL HIGH LIGATURE QAF WITH LAM WITH ALEF MAKSURA
      .replaceAll('\u06D8', '') //ARABIC SMALL HIGH MEEM INITIAL FORM
      .replaceAll('\u06D9', '') //ARABIC SMALL HIGH LAM ALEF
      .replaceAll('\u06DA', '') //ARABIC SMALL HIGH JEEM
      .replaceAll('\u06DB', '') //ARABIC SMALL HIGH THREE DOTS
      .replaceAll('\u06DC', '') //ARABIC SMALL HIGH SEEN
      .replaceAll('\u06DD', '') //ARABIC END OF AYAH
      .replaceAll('\u06DE', '') //ARABIC START OF RUB EL HIZB
      .replaceAll('\u06DF', '') //ARABIC SMALL HIGH ROUNDED ZERO
      .replaceAll('\u06E0', '') //ARABIC SMALL HIGH UPRIGHT RECTANGULAR ZERO
      .replaceAll('\u06E1', '') //ARABIC SMALL HIGH DOTLESS HEAD OF KHAH
      .replaceAll('\u06E2', '') //ARABIC SMALL HIGH MEEM ISOLATED FORM
      .replaceAll('\u06E3', '') //ARABIC SMALL LOW SEEN
      .replaceAll('\u06E4', '') //ARABIC SMALL HIGH MADDA
      .replaceAll('\u06E5', '') //ARABIC SMALL WAW
      .replaceAll('\u06E6', '') //ARABIC SMALL YEH
      .replaceAll('\u06E7', '') //ARABIC SMALL HIGH YEH
      .replaceAll('\u06E8', '') //ARABIC SMALL HIGH NOON
      .replaceAll('\u06E9', '') //ARABIC PLACE OF SAJDAH
      .replaceAll('\u06EA', '') //ARABIC EMPTY CENTRE LOW STOP
      .replaceAll('\u06EB', '') //ARABIC EMPTY CENTRE HIGH STOP
      .replaceAll('\u06EC', '') //ARABIC ROUNDED HIGH STOP WITH FILLED CENTRE
      .replaceAll('\u06ED', '') //ARABIC SMALL LOW MEEM

      //Remove tatweel
      .replaceAll('\u0640', '')

      //Remove tashkeel
      .replaceAll('\u064B', '') //ARABIC FATHATAN
      .replaceAll('\u064C', '') //ARABIC DAMMATAN
      .replaceAll('\u064D', '') //ARABIC KASRATAN
      .replaceAll('\u064E', '') //ARABIC FATHA
      .replaceAll('\u064F', '') //ARABIC DAMMA
      .replaceAll('\u0650', '') //ARABIC KASRA
      .replaceAll('\u0651', '') //ARABIC SHADDA
      .replaceAll('\u0652', '') //ARABIC SUKUN
      .replaceAll('\u0653', '') //ARABIC MADDAH ABOVE
      .replaceAll('\u0654', '') //ARABIC HAMZA ABOVE
      .replaceAll('\u0655', '') //ARABIC HAMZA BELOW
      .replaceAll('\u0656', '') //ARABIC SUBSCRIPT ALEF
      .replaceAll('\u0657', '') //ARABIC INVERTED DAMMA
      .replaceAll('\u0658', '') //ARABIC MARK NOON GHUNNA
      .replaceAll('\u0659', '') //ARABIC ZWARAKAY
      .replaceAll('\u065A', '') //ARABIC VOWEL SIGN SMALL V ABOVE
      .replaceAll('\u065B', '') //ARABIC VOWEL SIGN INVERTED SMALL V ABOVE
      .replaceAll('\u065C', '') //ARABIC VOWEL SIGN DOT BELOW
      .replaceAll('\u065D', '') //ARABIC REVERSED DAMMA
      .replaceAll('\u065E', '') //ARABIC FATHA WITH TWO DOTS
      .replaceAll('\u065F', '') //ARABIC WAVY HAMZA BELOW
      .replaceAll('\u0670', '') //ARABIC LETTER SUPERSCRIPT ALEF

      //Replace Waw Hamza Above by Waw
      .replaceAll('\u0624', '\u0648')

      //Replace Ta Marbuta by Ha
      .replaceAll('\u0629', '\u0647')

      //Replace Ya
      // and Ya Hamza Above by Alif Maksura
      .replaceAll('\u064A', '\u0649')
      .replaceAll('\u0626', '\u0649')

      // Replace Alifs with Hamza Above/Below
      // and with Madda Above by Alif
      .replaceAll('\u0622', '\u0627')
      .replaceAll('\u0623', '\u0627')
      .replaceAll('\u0625', '\u0627')
      .replaceAll('ٱ', 'ا');
}

// control in mushaf page
PageController HomePageController = PageController();
String hizbFormat(quranController quran) {
  // convert hizbQuarter to hidb like 1/2 hidb 1
  List number = (quran.hizbQuarter / 4 + 0.75).toString().split('.');
  String convert = number[1] == '25'
      ? '4/1'
      : number[1] == '5'
          ? '1/2'
          : '4/3';
  if (quran.ayahs.isNotEmpty)
  // if quotient 3 then show 1/2 else if quotient 2 then show 1/4 else show show 3/4
  if (quran.hizbQuarter % 4 == 2 ||
      quran.hizbQuarter % 4 == 3 ||
      quran.hizbQuarter % 4 == 0) {
    return '${quran.ayahs.first.hizbQuarter != quran.ayahs.last.hizbQuarter ? '${convert} الحزب ' + '${((quran.hizbQuarter / 4) + 0.75).toString().split('.')[0]} ' : ''}';
  } else {
    return '';
  }
  else
    return '';
}
