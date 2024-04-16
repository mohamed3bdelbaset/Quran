import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Model/ayah_model.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/search_widget.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class Drawer_widget extends StatefulWidget {
  const Drawer_widget({super.key});

  @override
  State<Drawer_widget> createState() => _Drawer_widgetState();
}

class _Drawer_widgetState extends State<Drawer_widget> {
  TextEditingController searchController = TextEditingController();
  List<Surahs_model> search_surah = [];
  String type = 'الفهرس';
  Map juz = {
    "1": 1,
    "2": 22,
    "3": 42,
    "4": 62,
    "5": 82,
    "6": 102,
    "7": 122,
    "8": 142,
    "9": 162,
    "10": 182,
    "11": 202,
    "12": 222,
    "13": 242,
    "14": 262,
    "15": 282,
    "16": 302,
    "17": 322,
    "18": 342,
    "19": 362,
    "20": 382,
    "21": 402,
    "22": 422,
    "23": 442,
    "24": 462,
    "25": 482,
    "26": 502,
    "27": 522,
    "28": 542,
    "29": 562,
    "30": 582
  };
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: context.ScreenWidth / 1.3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onSelected: (value) => type = value,
                position: PopupMenuPosition.under,
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'الفهرس',
                    child: Text('الفهرس',
                        style: TextStyle(
                            color: type == 'الفهرس'
                                ? Theme.of(context).hintColor
                                : null,
                            fontSize: context.MiddleFont)),
                  ),
                  PopupMenuItem(
                    value: 'الأحزاب',
                    child: Text('الأحزاب',
                        style: TextStyle(
                            color: type == 'الأحزاب'
                                ? Theme.of(context).hintColor
                                : null,
                            fontSize: context.MiddleFont)),
                  )
                ],
              )
            ],
            title: Align(
              alignment: Alignment.centerRight,
              child: Text('مصحف التلاوة ( $type )',
                  style: TextStyle(fontSize: context.MiddleFont)),
            ),
          ),
          body: Column(
            children: [
              if (type == 'الفهرس')
                search_widget(
                  controller: searchController,
                  margin: EdgeInsets.all(5),
                  hintText: 'ابحث عن اسم السورة',
                  borderRadius: 5.0,
                  onChanged: () {
                    search_surah.clear();
                    for (int i = 0; i < dates.surahs.length; i++)
                      if (dates.surahs[i].name.normalise
                          .contains(searchController.text.trim()))
                        search_surah.add(dates.surahs[i]);
                  },
                  onClear: () {
                    searchController.clear();
                    search_surah.clear();
                  },
                ),
              Expanded(
                  child: type == 'الفهرس' ? juzWidgetView() : hizbWidgetView())
            ],
          ),
        ),
      ),
    );
  }

  Padding surah(Surahs_model model) {
    quranController quran = BlocProvider.of<quranController>(context);
    bool curant_surah = quran.surahNumber == model.number;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListTile(
        shape: BeveledRectangleBorder(
            side: BorderSide(
                color: curant_surah ? Color(0xffa4abb6) : Colors.transparent)),
        onTap: () async {
          HomePageController.jumpToPage(model.ayahs.first.page - 1);
          Navigator.pop(context);
        },
        title: SvgPicture.asset(
          'assets/surah_name/00${model.number}.svg',
          alignment: Alignment.centerRight,
          height: 30,
          colorFilter: ColorFilter.mode(context.defaultColor, BlendMode.srcIn),
        ),
        subtitle: Text(
          'رقمها ${model.number}  أياتها ${model.ayahs.length}  ${model.revelationType.tr}'
              .replaceFarsi,
          style: TextStyle(fontSize: context.MiddleFont / 1.1),
        ),
        trailing: Container(
          height: context.ScreenWidth / 12,
          width: context.ScreenWidth / 12,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: curant_surah
                  ? Color(0xffa4abb6)
                  : Theme.of(context).focusColor,
              shape: BoxShape.circle),
          child: Text(
            model.ayahs.first.page.toString().replaceFarsi,
            style: TextStyle(
                color: curant_surah
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).textTheme.titleLarge!.color,
                fontSize: context.MiddleFont / 1.1),
          ),
        ),
      ),
    );
  }

  CupertinoScrollbar juzWidgetView() {
    bool searchOff = searchController.text.isEmpty;
    ScrollController controller = ScrollController();
    return CupertinoScrollbar(
      controller: controller,
      child: ListView.builder(
        itemCount: searchOff ? 30 : search_surah.length,
        key: PageStorageKey('value'),
        controller: controller,
        itemBuilder: (context, index) {
          if (searchOff) {
            return StickyHeader(
              header: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      fixedSize:
                          Size(context.ScreenWidth, context.ScreenHeight / 22),
                      alignment: Alignment.centerRight,
                      shape: RoundedRectangleBorder(),
                      padding: EdgeInsets.only(right: 25)),
                  onPressed: () async {
                    HomePageController.jumpToPage(juz['${index + 1}'] - 1);
                    Navigator.pop(context);
                  },
                  child: Text('الجزء ${index + 1}'.replaceFarsi,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontSize: context.MiddleFont)),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...dates.surahs.map((e) {
                    if (e.ayahs.first.juz == index + 1) return surah(e);
                    return SizedBox();
                  })
                ],
              ),
            );
          } else {
            return surah(search_surah[index]);
          }
        },
      ),
    );
  }

  CupertinoScrollbar hizbWidgetView() {
    ScrollController controller = ScrollController();
    quranController quran = BlocProvider.of<quranController>(context);
    return CupertinoScrollbar(
      controller: controller,
      child: ListView.builder(
        itemCount: 30,
        controller: controller,
        key: PageStorageKey('value'),
        itemBuilder: (context, index) => StickyHeader(
          header: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  fixedSize:
                      Size(context.ScreenWidth, context.ScreenHeight / 22),
                  alignment: Alignment.centerRight,
                  shape: RoundedRectangleBorder(),
                  padding: EdgeInsets.only(right: 25)),
              onPressed: () async {
                HomePageController.jumpToPage(juz['${index + 1}'] - 1);
                Navigator.pop(context);
              },
              child: Text('الجزء ${index + 1}'.replaceFarsi,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      fontSize: context.MiddleFont)),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < dates.surahs.length; i++)
                for (int e = 0; e < dates.surahs[i].ayahs.length; e++)
                  if (('${dates.surahs[i].ayahs[e].text}'.contains('\u06de') ||
                          dates.surahs[i].ayahs[e].hizbFirst != null) &&
                      dates.surahs[i].ayahs[e].juz == index + 1)
                    ListTile(
                      trailing: Container(
                        height: context.ScreenWidth / 12,
                        width: context.ScreenWidth / 12,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: quran.ayahs.last.hizbQuarter ==
                                    dates.surahs[i].ayahs[e].hizbQuarter
                                ? Color(0xffa4abb6)
                                : Theme.of(context).focusColor,
                            shape: BoxShape.circle),
                        child: Text(
                          '${dates.surahs[i].ayahs[e].page}'.replaceFarsi,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                              fontSize: context.MiddleFont * 1.1),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.transparent)),
                      onTap: () {
                        HomePageController.jumpToPage(
                            dates.surahs[i].ayahs[e].page - 1);
                        Navigator.pop(context);
                      },
                      leading: SizedBox(
                          width: context.IconSize * 1.2,
                          child: hizbWidget(i, e)),
                      title: Text(
                          maxLines: 2,
                          dates.surahs[i].ayahs[e].text.contains('\u06de')
                              ? '${dates.surahs[i].ayahs[e].text.split('\u06de')[1]}'
                              : dates.surahs[i].ayahs[e].text,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                              fontSize: context.SmallFont)),
                      subtitle: Text(
                        'رقمها ${dates.surahs[i].number}   ${dates.surahs[i].name.replaceAll('سُورَةُ', '')} ${dates.surahs[i].ayahs[e].numberInSurah}'
                            .replaceFarsi,
                        style: TextStyle(fontSize: context.SmallFont / 1.1),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget hizbWidget(int i, int e) {
    double hizb = double.parse(((dates.surahs[i].ayahs[e].hizbQuarter - 1) / 4)
        .toString()
        .split('.')[1]);
    if ((dates.surahs[i].ayahs[e].hizbQuarter - 1) % 4 == 0) {
      return Text(
          '  ${(((dates.surahs[i].ayahs[e].hizbQuarter + 1) / 4)).round()}',
          style: TextStyle(fontSize: context.MiddleFont));
    } else {
      if (hizb == 25.00) {
        return Image.asset('assets/hizb_parts/quarter.png',
            height: context.IconSize,
            alignment: Alignment.topRight,
            color: Theme.of(context).hintColor.withAlpha(150));
      } else if (hizb == 5.0) {
        return Image.asset('assets/hizb_parts/half.png',
            height: context.IconSize * 1.5,
            alignment: Alignment.centerRight,
            color: Theme.of(context).hintColor.withAlpha(150));
      } else {
        return Image.asset('assets/hizb_parts/3quarter.png',
            height: context.IconSize * 1.5,
            color: Theme.of(context).hintColor.withAlpha(150));
      }
    }
  }
}
