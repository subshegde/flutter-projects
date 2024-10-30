class TimePeriod {
  TimePeriod();

  String getTimePeriod(DateTime time) {
    try {
      int hour = time.hour;

      if (hour < 12) {
        return 'Good Morning';
      } else if (hour < 17) {
        return 'Good Afternoon';
      } else if (hour < 20) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    } catch (e) {
      print('Error parsing time: $e');
      return '';
    }
  }
}
