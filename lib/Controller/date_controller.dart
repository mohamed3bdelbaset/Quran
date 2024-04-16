import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:seventh_project/Model/ayah_model.dart';
import 'package:seventh_project/Model/reciter_model.dart';

class dates {
  static List<Surahs_model> surahs = [];
  static List<Reciter_model> reciter = [];
  static Future<void> _readJson(String root) async {
    final String response =
        await rootBundle.loadString('assets/data/$root.json');
    final data = await json.decode(response);

    if (root == 'quranV2') {
      for (int i = 0; i < data['surahs'].length; i++)
        surahs.add(Surahs_model.fromjson(data['surahs'][i]));
    } else if (root == 'reciter') {
      for (int i = 0; i < data.length; i++)
        reciter.add(Reciter_model.fromjson(data[i]));
    }
// ...
  }

  static Future getQuranDate() async {
    return Future.wait([
      _readJson('quranV2'),
      _readJson('reciter'),
    ]);
  }
}
