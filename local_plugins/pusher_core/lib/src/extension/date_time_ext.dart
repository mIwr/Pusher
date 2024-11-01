
extension DateTimeExt on DateTime {

  int get daysInMonth {
    return DateTimeExt.daysInMonthOfYear(month, year: year);
  }

  static int daysInMonthOfYear(int month, {int? year}) {
    var validatedMonth = month;
    if (validatedMonth < 0 || validatedMonth > 12) {
      return 0;
    }
    if (month == 0) {
      validatedMonth++;
    }
    final safeYear = year ?? DateTime.now().year;
    switch (validatedMonth) {
      case 1: return 31;
      case 2: return safeYear % 4 == 0 ? 29 : 28;
      case 3: return 31;
      case 4: return 30;
      case 5: return 31;
      case 6: return 30;
      case 7: return 31;
      case 8: return 31;
      case 9: return 30;
      case 10: return 31;
      case 11: return 30;
      case 12: return 31;
    }
    return 0;
  }
}