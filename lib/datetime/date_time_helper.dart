//converts DateTime to string format yyymmdd
String convertDateTimeToString(DateTime dateTime) {
  //year format
  String year = dateTime.year.toString();

  //month format
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day format
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  //combine to yyyy-mm-dd
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
