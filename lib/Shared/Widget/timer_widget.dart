import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventh_project/Controller/timer_controller.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class Timer_widget extends StatefulWidget {
  const Timer_widget({super.key});

  @override
  State<Timer_widget> createState() => _Timer_widgetState();
}

class _Timer_widgetState extends State<Timer_widget> {
  late Timer timer;
  int second = 0;
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      BlocProvider.of<TimerController>(context).change(second += 1);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          timeHandel('ثانية', '${durationFormat().$3}'),
          Text(' : ', style: TextStyle(fontSize: context.MiddleFont)),
          timeHandel('دقيقة', durationFormat().$2),
          Text(' : ', style: TextStyle(fontSize: context.MiddleFont)),
          timeHandel('ساعة', durationFormat().$1)
        ],
      ),
    );
  }

  (String, String, String) durationFormat() {
    ReadDuration = Duration(seconds: second);
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
      children: [
        Text(time, style: TextStyle(fontSize: context.MiddleFont)),
        Text(type, style: TextStyle(fontSize: context.MiddleFont / 1.1))
      ],
    );
  }
}
