import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventh_project/Controller/history_controller.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/duration_widget.dart';

class doneDialog_widget extends StatefulWidget {
  const doneDialog_widget({super.key});

  @override
  State<doneDialog_widget> createState() => _doneDialog_widgetState();
}

class _doneDialog_widgetState extends State<doneDialog_widget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Text('هل أنهيت الحفظ؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: context.MiddleFont * 1.3)),
      actionsPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              fixedSize:
                  Size(context.ScreenWidth / 3.5, context.ScreenHeight / 20)),
          onPressed: showTakenTime,
          child: Text('نعم', style: TextStyle(fontSize: context.MiddleFont)),
        ),
        TextButton(
          style: TextButton.styleFrom(
              fixedSize:
                  Size(context.ScreenWidth / 3.5, context.ScreenHeight / 20)),
          onPressed: () => Navigator.pop(context),
          child: Text('لا', style: TextStyle(fontSize: context.MiddleFont)),
        )
      ],
    );
  }

  void Function()? showTakenTime() {
    sendData();
    Navigator.pop(context);
    ayahPlayer.stop();
    itemsPositionList.clear();
    showStartButton = false;
    showTimer = false;
    toVerseSelect = 0;
    showDialog(context: context, builder: (context) => Duration_widget());
    return null;
  }

  void sendData() {
    quranController quran = BlocProvider.of<quranController>(context);
    final data = {
      'surah': quran.surahNumber,
      'pageDetail':
          'صفحة  ${quran.page}  جزء ${quran.juz} ${hizbFormat(quran)}',
      'timeTaken':
          '${durationFormat().$3} ثانية ${durationFormat().$2} دقيقة ${durationFormat().$1} ساعة',
      'day': DateTime.now().millisecondsSinceEpoch,
      'ayahs':
          '[ ${itemsPositionListinSurah.first} - ${itemsPositionListinSurah.last} ]'
    };
    HistoryController.sendHistory(data);
  }

  (String, String, String) durationFormat() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes =
        twoDigits(ReadDuration.inMinutes.remainder(60).abs());
    String twoDigitSeconds =
        twoDigits(ReadDuration.inSeconds.remainder(60).abs());
    return (
      "${twoDigits(ReadDuration.inHours)}",
      '$twoDigitMinutes',
      '$twoDigitSeconds'
    );
  }
}
