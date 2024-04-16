import 'package:flutter/material.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class Duration_widget extends StatefulWidget {
  const Duration_widget({super.key});

  @override
  State<Duration_widget> createState() => _Duration_widgetState();
}

class _Duration_widgetState extends State<Duration_widget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      title: Text('الوقت المستغرق للحفظ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: context.MiddleFont * 1.3)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          timeHandel('ثانية', '${durationFormat().$3}'),
          Text(' : ', style: TextStyle(fontSize: context.LargeFont)),
          timeHandel('دقيقة', durationFormat().$2),
          Text(' : ', style: TextStyle(fontSize: context.LargeFont)),
          timeHandel('ساعة', durationFormat().$1)
        ],
      ),
      actionsPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              fixedSize:
                  Size(context.ScreenWidth / 1.5, context.ScreenHeight / 20)),
          onPressed: () => Navigator.pop(context),
          child: Text('العودة  الي المصحف',
              style: TextStyle(fontSize: context.MiddleFont)),
        ),
      ],
    );
  }

  (String, String, String) durationFormat() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes =
        twoDigits(ReadDuration.inMinutes.remainder(60).abs());
    String twoDigitSeconds =
        twoDigits(ReadDuration.inSeconds.remainder(60).abs());
    return (
      "${twoDigits(ReadDuration.inHours)}:",
      '$twoDigitMinutes:',
      '$twoDigitSeconds'
    );
  }

  Column timeHandel(String time, String type) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(time, style: TextStyle(fontSize: context.MiddleFont * 1.1)),
        Text(type, style: TextStyle(fontSize: context.MiddleFont))
      ],
    );
  }
}
