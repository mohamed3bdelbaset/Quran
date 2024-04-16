// import 'dart:io'show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Shared/Screen/history_screen.dart';
import 'package:seventh_project/Shared/Screen/search_screen.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/MushafView_widget.dart';
import 'package:seventh_project/Shared/Widget/buttomNavigation_widget.dart';
import 'package:seventh_project/Shared/Widget/drawer_widget.dart';
import 'package:seventh_project/Shared/Widget/tafsserveiw_widget.dart';
import 'package:seventh_project/Shared/Widget/timer_widget.dart';
import 'package:seventh_project/States/quran_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mushaf_screen extends StatefulWidget {
  const Mushaf_screen({super.key});

  @override
  State<Mushaf_screen> createState() => _Mushaf_screenState();
}

class _Mushaf_screenState extends State<Mushaf_screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool openning = false;
  @override
  void initState() {
    // get quran and reciter data from json file
    dates.getQuranDate().whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<quranController, QuranState>(
      builder: (context, state) {
        quranController quran = BlocProvider.of<quranController>(context);
        return GestureDetector(
          onTap: () {
            // to show bottom Navigation Bar
            if (!showTimer && itemsPositionList.isEmpty) showMore = !showMore;
          },
          child: Scaffold(
            key: _scaffoldKey,
            drawer: Drawer_widget(),
            body: Dismissible(
              key: Key('value'),
              direction: itemsPositionList.isEmpty
                  ? DismissDirection.down
                  : DismissDirection.none,
              confirmDismiss: (direction) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Search_screen())),
              child: PageView.builder(
                itemCount: 604,
                controller: HomePageController,
                onPageChanged: save_page,
                physics: itemsPositionList.isEmpty
                    ? ClampingScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (!openning) get_page();
                  // to get page ayahs
                  if (openning) {
                    quran.getDate(index);
                    if (dates.surahs.isNotEmpty)
                      return Scaffold(
                        appBar: AppBar(
                          centerTitle: false,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          title: GestureDetector(
                            onTap: itemsPositionList.isEmpty
                                ? () => _scaffoldKey.currentState!.openDrawer()
                                : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/surah_name/00${quran.surahNumber}.svg',
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                      context.defaultColor, BlendMode.srcIn),
                                ),
                                Text(
                                    'صفحة  ${quran.page}  جزء ${quran.juz} ${hizbFormat(quran)}'
                                        .replaceFarsi,
                                    style: TextStyle(
                                        color: context.defaultColor,
                                        fontSize: context.MiddleFont))
                              ],
                            ),
                          ),
                          automaticallyImplyLeading: false,
                          actions: [
                            if (showTimer) Timer_widget(),
                            if (showMore && !showStartButton && !showTimer)
                              IconButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              History_screen())),
                                  icon: Icon(Icons.history,
                                      size: context.IconSize))
                          ],
                        ),
                        bottomNavigationBar: ButtomNavigation_widget(),
                        body: showTafsser
                            ? TafsserView_widget()
                            : MushafView_widget(),
                      );
                  }
                  return null;
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void Function(int)? save_page(int index) {
    // add page position to cache So that when the program opens the next time, this page will be
    SharedPreferences.getInstance()
        .then((value) => value.setInt('page', index));
    return null;
  }

  void get_page() async {
    // get page position to cache
    int index = 0;
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (shared.getInt('page') != null) {
      index = shared.getInt('page')!;
    } else {
      index = 0;
    }
    HomePageController.jumpToPage(index);
    openning = true;
  }
}
