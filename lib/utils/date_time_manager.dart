class DateTimeManager {
  static String currentDate() {
    DateTime dateTime = DateTime.now();
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}  ${dateTime.hour}/${dateTime.minute}';
  }
}
