import 'package:intl/intl.dart';

class DurationFormatter {
  static String format(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final NumberFormat twoDigits = NumberFormat('00');
    final String hoursStr = twoDigits.format(hours);
    final String minutesStr = twoDigits.format(minutes);
    final String secondsStr = twoDigits.format(seconds);

    if (hours > 0) {
      return '$hoursStr:$minutesStr:$secondsStr';
    } else {
      return '$minutesStr:$secondsStr';
    }
  }
}