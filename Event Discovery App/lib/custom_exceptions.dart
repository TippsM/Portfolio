class TimeException implements Exception {
  String msg;
  TimeException(this.msg);
  @override
  String toString() => 'timeException: $msg';
}

class DateException implements Exception {
  String msg;
  DateException(this.msg);
  @override
  String toString() => 'dateException: $msg';
}
