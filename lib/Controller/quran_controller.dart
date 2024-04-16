import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Model/ayah_model.dart';
// import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/States/quran_state.dart';

class quranController extends Cubit<QuranState> {
  quranController() : super(InitalState());
  List<Ayah> ayahs = [];
  late Surahs_model surah;
  int page = 1;
  //  int customPage = 1;
  int surahSelectNumber = 0;
  int numberisbefore = 0;
  int surahNumber = 0;
  String surahName = '';
  int juz = 1;
  int hizbQuarter = 0;

  void getDate(int index) {
    ayahs.clear();
    for (int i = 0; i < dates.surahs.length; i++) {
      for (int e = 0; e < dates.surahs[i].ayahs.length; e++) {
        if (dates.surahs[i].ayahs[e].page == index + 1) {
          ayahs.add(dates.surahs[i].ayahs[e]);
          // surah list continue 114 items (surah Al-Falaq)
          if (i != 113) numberisbefore = dates.surahs[i + 1].number;
          surahNumber = dates.surahs[i].number;
          surahName = dates.surahs[i].name;
          juz = dates.surahs[i].ayahs[e].juz;
          hizbQuarter = dates.surahs[i].ayahs[e].hizbQuarter;
          page = dates.surahs[i].ayahs[e].page;
        }
      }
      emit(navigationState());
    }
  }

  bool lastAyah(int ayahNumber) {
    // last ayah in surah number in quran
    List last = [
      493,
      669,
      1364,
      1473,
      1596,
      1750,
      1901,
      2140,
      2348,
      2595,
      2673,
      2791,
      2855,
      2932,
      3159,
      3252,
      3340,
      3409,
      3503,
      3533,
      3660,
      3705,
      3788,
      3970,
      4058,
      4133,
      4325,
      4473,
      4510,
      4545,
      4612,
      4675,
      4735,
      4784,
      4846,
      4901,
      4979,
      5075,
      5126,
      5150,
      5163,
      5188,
      5199,
      5217,
      5271,
      5323,
      5375,
      5419,
      5495,
      5551,
      5591,
      5622,
      5712,
      5758,
      5800,
      5848,
      5884,
      5909,
      5948,
      5967,
      5993,
      6023,
      6043,
      6058,
      6079,
      6090,
      6098,
      6106,
      6125,
      6130,
      6138,
      6146,
      6157,
      6168,
      6179,
      6188,
      6197,
      6204,
      6213,
      6216,
      6225,
      6230,
    ];
    return last.contains(ayahNumber);
  }

  List surahsStartBefore() {
    // pages surah start before basmallah
    return [
      76,
      207,
      331,
      341,
      349,
      366,
      376,
      414,
      417,
      445,
      452,
      498,
      506,
      525,
      548,
      555,
      557,
      584
    ];
  }

  // Future handelPage() async {
  //   // Jump to the next or previous page depending number in surah
  //   for (int i = 0; i < dates.surahs.length; i++)
  //     for (int e = 0; e < dates.surahs[i].ayahs.length; e++)
  //       if (dates.surahs[i].ayahs[e].number == numberselect)
  //         HomePageController.jumpToPage(dates.surahs[i].ayahs[e].page - 1);
  // }
}
