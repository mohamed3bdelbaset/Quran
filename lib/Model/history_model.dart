class HistoryModel {
  int day;
  int surah;
  String ayahs;
  String pageDetail;
  String timeTaken;
  HistoryModel(
      {required this.day,
      required this.surah,
      required this.ayahs,
      required this.pageDetail,
      required this.timeTaken});

  HistoryModel.fromJson(Map json)
      : this(
            day: json['day'],
            surah: json['surah'],
            ayahs: json['ayahs'],
            pageDetail: json['pageDetail'],
            timeTaken: json['timeTaken']);
}
