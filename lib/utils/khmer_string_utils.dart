class KhmerStringUtils {
  static const List<String> khmerDigits = [
    '០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'
  ];

  /// បំប្លែងលេខអារ៉ាប់ (Arabic Digits) ទៅជាលេខខ្មែរ (Khmer Digits)
  static String toKhmerDigits(dynamic input) {
    if (input == null) return '';
    String str = input.toString();
    String result = str;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(i.toString(), khmerDigits[i]);
    }
    return result;
  }

  /// បំពេញលេខ 0 ខាងមុខ និងបំប្លែងជាលេខខ្មែរ (e.g. 5 -> "០៥")
  static String formatTwoDigits(int number, {bool useKhmerDigits = true}) {
    String formatted = number.toString().padLeft(2, '0');
    return useKhmerDigits ? toKhmerDigits(formatted) : formatted;
  }

  /// ឈ្មោះខែខ្មែរ
  static const List<String> khmerMonths = [
    'មករា', 'កុម្ភៈ', 'មីនា', 'មេសា', 'ឧសភា', 'មិថុនា',
    'កក្កដា', 'សីហា', 'កញ្ញា', 'តុលា', 'វិច្ឆិកា', 'ធ្នូ'
  ];

  /// ឈ្មោះខែអង់គ្លេស
  static const List<String> englishMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  /// ទទួលបានឈ្មោះខែតាមភាសា/លេខដែលបានជ្រើសរើស
  static String getMonthName(int month, {bool useKhmerDigits = true}) {
    if (month < 1 || month > 12) return '';
    return useKhmerDigits ? khmerMonths[month - 1] : englishMonths[month - 1];
  }
}
