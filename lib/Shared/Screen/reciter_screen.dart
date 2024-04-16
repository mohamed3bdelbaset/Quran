import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seventh_project/Controller/date_controller.dart';
import 'package:seventh_project/Model/reciter_model.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/search_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reciter_screen extends StatefulWidget {
  const Reciter_screen({super.key});

  @override
  State<Reciter_screen> createState() => _Reciter_screenState();
}

class _Reciter_screenState extends State<Reciter_screen> {
  TextEditingController searchController = TextEditingController();
  List<Reciter_model> searchReciter = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('القراء'),
      ),
      body: Column(
        children: [
          search_widget(
            controller: searchController,
            hintText: 'ابحث عن اسم القارئ',
            onChanged: () {
              searchReciter.clear();
              for (int i = 0; i < dates.reciter.length; i++)
                if (dates.reciter[i].name
                    .trim()
                    .contains(searchController.text.trim()))
                  searchReciter.add(dates.reciter[i]);
              setState(() {});
            },
            onClear: () {
              searchController.clear();
              searchReciter.clear();
              setState(() {});
            },
          ),
          Expanded(
            child: CupertinoScrollbar(
              child: ListView.builder(
                itemCount: searchController.text.isEmpty
                    ? dates.reciter.length
                    : searchReciter.length,
                itemBuilder: (context, index) => reciterViewWidget(
                    searchController.text.isEmpty
                        ? dates.reciter[index]
                        : searchReciter[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future setCacheReciter(Reciter_model model) async {
    // add qari data to cache
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setStringList('qari',
        [model.date, model.englishName, model.image, model.code, model.name]);
    List cache = shared.getStringList('qari')!;
    cacheReciter = Reciter_model(
        date: cache[0],
        englishName: cache[1],
        image: cache[2],
        code: cache[3],
        name: cache[4]);
    Navigator.pop(context);
  }

  Container reciterViewWidget(Reciter_model model) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: cacheReciter.date == model.date
                  ? Theme.of(context).hintColor
                  : Colors.transparent)),
      child: ListTile(
          onTap: () => setCacheReciter(model),
          leading: CircleAvatar(
            minRadius: context.IconSize,
            maxRadius: context.IconSize,
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(model.image),
          ),
          title:
              Text(model.name, style: TextStyle(fontSize: context.MiddleFont))),
    );
  }
}
