class Surahs_model {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  String themes;
  String englishthemes;
  String? called;
  String? englishCalled;
  List<Ayah> ayahs;

  Surahs_model({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.themes,
    required this.englishthemes,
    this.called,
    this.englishCalled,
    required this.ayahs,
  });

  factory Surahs_model.fromjson(Map data) {
    return Surahs_model(
        number: data['number'],
        name: data['name'],
        englishName: data['englishName'],
        englishNameTranslation: data['englishNameTranslation'],
        revelationType: data['revelationType'],
        themes: data['themes'],
        englishthemes: data['englishthemes'],
        called: data['called'],
        englishCalled: data['englishCalled'],
        ayahs: [
          for (int i = 0; i < data['ayahs'].length; i++)
            Ayah.fromjson(data['ayahs'][i])
        ]);
  }
}

class Ayah {
  int number;
  int? surahNumber;
  String tafsser;
  String translation;
  String transliteration;
  String aya_text_emlaey;
  String code_v2;
  String text;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;
  bool? hizbFirst;

  Ayah(
      {required this.number,
      this.surahNumber,
      required this.tafsser,
      required this.translation,
      required this.transliteration,
      required this.aya_text_emlaey,
      required this.code_v2,
      required this.text,
      required this.numberInSurah,
      required this.juz,
      required this.manzil,
      required this.page,
      required this.ruku,
      this.hizbFirst,
      required this.hizbQuarter});
  factory Ayah.fromjson(Map data) {
    return Ayah(
        number: data['number'],
        surahNumber: data['surahNumber'],
        tafsser: data['tafsser'],
        translation: data['translation'],
        transliteration: data['transliteration'],
        aya_text_emlaey: data['aya_text_emlaey'],
        code_v2: data['code_v2'],
        text: data['text'],
        numberInSurah: data['numberInSurah'],
        juz: data['juz'],
        manzil: data['manzil'],
        page: data['page'],
        ruku: data['ruku'],
        hizbQuarter: data['hizbQuarter'],
        hizbFirst: data['hizbFirst']);
  }
}
