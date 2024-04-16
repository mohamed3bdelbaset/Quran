class Reciter_model {
  String name;
  String englishName;
  String date;
  String code;
  String image;
  Reciter_model(
      {required this.date,
      required this.englishName,
      required this.image,
      required this.code,
      required this.name});

  factory Reciter_model.fromjson(Map dateFile) {
    return Reciter_model(
        date: dateFile['Data'],
        englishName: dateFile['englishName'],
        image: dateFile['image'],
        code: dateFile['Code'],
        name: dateFile['Name']);
  }
}
