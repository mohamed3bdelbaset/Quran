abstract class TimerState {}

class DurationChangeState extends TimerState {
  int seconds;
  DurationChangeState(this.seconds);
}
