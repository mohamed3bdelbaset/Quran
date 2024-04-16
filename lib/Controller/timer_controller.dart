import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventh_project/States/timer_state.dart';

class TimerController extends Cubit {
  TimerController() : super(DurationChangeState(0));

  void change(int second) {
    emit(DurationChangeState(second));
  }
}
