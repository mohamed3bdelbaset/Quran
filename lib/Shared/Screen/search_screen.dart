import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Model/ayah_model.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/search_widget.dart';

class Search_screen extends StatefulWidget {
  const Search_screen({super.key});

  @override
  State<Search_screen> createState() => _Search_screenState();
}

class _Search_screenState extends State<Search_screen> {
  List<Ayah> searchAyahResult = [];
  List<Surahs_model> searchSurahResult = [];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          searchBar_widget(),
          if (searchSurahResult.isNotEmpty)
            Container(
              height: context.ScreenHeight / 22,
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                'السورة : ${searchSurahResult.length} نتائج'.replaceFarsi,
                style: TextStyle(fontSize: context.MiddleFont),
              ),
            ),
          ...searchSurahResult.map(
            (e) => ListTile(
              onTap: () {
                HomePageController.jumpToPage(e.ayahs.first.page - 1);
                Navigator.pop(context);
              },
              title: SvgPicture.asset(
                'assets/surah_name/00${e.number}.svg',
                alignment: Alignment.centerRight,
                height: 30,
                colorFilter:
                    ColorFilter.mode(context.defaultColor, BlendMode.srcIn),
              ),
              subtitle: Text(
                '${e.revelationType.tr} * اياتها ${e.ayahs.length}'
                    .replaceFarsi,
                style: TextStyle(fontSize: context.MiddleFont),
              ),
            ),
          ),
          if (searchAyahResult.isNotEmpty)
            Container(
              height: context.ScreenHeight / 22,
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                'النص القراني : ${searchAyahResult.length} نتائج'.replaceFarsi,
                style: TextStyle(fontSize: context.MiddleFont),
              ),
            ),
          ...searchAyahResult.map(
            (e) => ListTile(
              onTap: () {
                HomePageController.jumpToPage(e.page - 1);
                Navigator.pop(context);
              },
              title: Text(
                e.text,
                style: TextStyle(
                    fontSize: context.MiddleFont / 1.05,
                    fontFamily: 'page${e.page}'),
              ),
              subtitle: Text(
                ' ${e.numberInSurah} '.replaceFarsi +
                    dates.surahs[e.surahNumber! - 1].name
                        .replaceAll('سُورَةُ ', '') +
                    ' - صفحة ${e.page}'.replaceFarsi,
                style: TextStyle(fontSize: context.MiddleFont / 1.05),
              ),
            ),
          ),
        ],
      ),
    );
  }

  search_widget searchBar_widget() {
    return search_widget(
      autofocus: true,
      controller: searchController,
      hintText: 'ابحث عن اسم السورة او الآية',
      margin: EdgeInsets.only(left: 10, right: 10),
      onChanged: () {
        searchAyahResult.clear();
        searchSurahResult.clear();
        for (int i = 0; i < dates.surahs.length; i++) {
          // to search about surahs
          if (dates.surahs[i].name.normalise.contains(searchController.text))
            searchSurahResult.add(dates.surahs[i]);
          for (int e = 0; e < dates.surahs[i].ayahs.length; e++) {
            // to search about ayahs
            if (dates.surahs[i].ayahs[e].aya_text_emlaey
                .contains(searchController.text)) {
              Ayah ayah = dates.surahs[i].ayahs[e];
              searchAyahResult.add(Ayah(
                  surahNumber: dates.surahs[i].number,
                  number: ayah.number,
                  tafsser: ayah.tafsser,
                  translation: ayah.translation,
                  transliteration: ayah.transliteration,
                  aya_text_emlaey: ayah.aya_text_emlaey,
                  code_v2: ayah.code_v2,
                  text: ayah.text,
                  numberInSurah: ayah.numberInSurah,
                  juz: ayah.juz,
                  manzil: ayah.manzil,
                  page: ayah.page,
                  ruku: ayah.ruku,
                  hizbQuarter: ayah.hizbQuarter));
            }
          }
        }
        setState(() {});
      },
      onClear: () {
        searchAyahResult.clear();
        searchSurahResult.clear();
        searchController.clear();
        setState(() {});
      },
    );
  }
}
