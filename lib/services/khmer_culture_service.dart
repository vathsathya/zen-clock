import '../utils/khmer_string_utils.dart';

class KhmerCultureService {
  static const List<String> _zodiacAnimalsKhmer = [
    'ជូត (កណ្តុរ)', 'ឆ្លូវ (គោ)', 'ខាល (ខ្លា)', 'ថោះ (ទន្សាយ)',
    'រោង (នាគ)', 'ម្សាញ់ (ពស់)', 'មមី (សេះ)', 'មមែ (ពពែ)',
    'វក (ស្វា)', 'រកា (មាន់)', 'ច (ឆ្កែ)', 'កុរ (ជ្រូក)'
  ];

  static const List<String> _zodiacAnimalsEnglish = [
    'Rat (Chhoot)', 'Ox (Chhlov)', 'Tiger (Khal)', 'Rabbit (Thoh)',
    'Dragon (Roang)', 'Snake (Msanh)', 'Horse (Momee)', 'Goat (Momae)',
    'Monkey (Vok)', 'Rooster (Roka)', 'Dog (Chor)', 'Pig (Kor)'
  ];

  static const List<String> _erasKhmer = [
    'ឯកស័ក', 'ទោស័ក', 'ត្រីស័ក', 'ចត្វាស័ក', 'បញ្ចស័ក',
    'ឆស័ក', 'សប្តស័ក', 'អដ្ឋស័ក', 'នព្វស័ក', 'សំរិទ្ធិស័ក'
  ];

  static const List<String> _erasEnglish = [
    '1st Era (Ek-sak)', '2nd Era (Tho-sak)', '3rd Era (Trei-sak)', '4th Era (Chotta-sak)', '5th Era (Pancha-sak)',
    '6th Era (Chha-sak)', '7th Era (Sapta-sak)', '8th Era (Auttha-sak)', '9th Era (Noppha-sak)', '10th Era (Samritthe-sak)'
  ];

  /// Calculate traditional Khmer Zodiac Animal and Era for a given year
  static String getKhmerZodiacAndEra(int year, {bool useKhmerDigits = true}) {
    int zodiacIndex = (year - 4) % 12;
    int eraIndex = (year - 4) % 10;
    
    if (zodiacIndex < 0) zodiacIndex += 12;
    if (eraIndex < 0) eraIndex += 10;

    if (useKhmerDigits) {
      return "ឆ្នាំ${_zodiacAnimalsKhmer[zodiacIndex]} ${_erasKhmer[eraIndex]}";
    } else {
      return "Year of the ${_zodiacAnimalsEnglish[zodiacIndex]}, ${_erasEnglish[eraIndex]}";
    }
  }

  /// Get next upcoming Cambodian National Holiday and countdown string
  static String? getUpcomingHolidayCountdown(DateTime now, {bool useKhmerDigits = true}) {
    final currentYear = now.year;
    final holidays = _getHolidays(currentYear);

    for (var holiday in holidays) {
      if (holiday.date.isAfter(now) || (holiday.date.year == now.year && holiday.date.month == now.month && holiday.date.day == now.day)) {
        int daysLeft = holiday.date.difference(DateTime(now.year, now.month, now.day)).inDays;
        final name = useKhmerDigits ? holiday.nameKhmer : holiday.nameEnglish;
        final daysLeftStr = useKhmerDigits ? KhmerStringUtils.toKhmerDigits(daysLeft.toString()) : daysLeft.toString();

        if (daysLeft == 0) {
          return useKhmerDigits ? "🎉 ថ្ងៃនេះជាថ្ងៃ$name!" : "🎉 Today is $name!";
        } else if (daysLeft <= 30) {
          return useKhmerDigits ? "🇰🇭 នៅសល់ $daysLeftStr ថ្ងៃទៀតដល់ $name" : "🇰🇭 $daysLeftStr days left until $name";
        }
      }
    }
    return null;
  }

  /// Check if the day is a traditional Khmer Holy Day (ថ្ងៃសីល ៨កើត/១៥កើត/៨រោច/១៥រោច)
  static bool isKhmerHolyDay(DateTime now) {
    int day = now.day;
    return day == 8 || day == 15 || day == 23 || day == 30;
  }

  static String _getOrdinal(int num) {
    if (num == 1) return "1st";
    if (num == 2) return "2nd";
    if (num == 3) return "3rd";
    return "${num}th";
  }

  static String getKhmerLunarDayString(DateTime now, {bool useKhmerDigits = true}) {
    int day = now.day;
    if (useKhmerDigits) {
      if (day <= 15) {
        return "${KhmerStringUtils.toKhmerDigits(day)} កើត";
      } else {
        return "${KhmerStringUtils.toKhmerDigits(day - 15)} រោច";
      }
    } else {
      if (day <= 15) {
        return "${_getOrdinal(day)} Waxing";
      } else {
        return "${_getOrdinal(day - 15)} Waning";
      }
    }
  }

  static String? getHolidayName(DateTime date, {bool useKhmerDigits = true}) {
    final holidays = _getHolidays(date.year);
    for (var h in holidays) {
      if (h.date.year == date.year && h.date.month == date.month && h.date.day == date.day) {
        return useKhmerDigits ? h.nameKhmer : h.nameEnglish;
      }
    }
    return null;
  }

  static List<CultureHoliday> getMonthlyHolidays(int year, int month, {bool useKhmerDigits = true}) {
    final holidays = _getHolidays(year);
    return holidays.where((h) => h.date.month == month).toList();
  }

  static List<CultureHoliday> _getHolidays(int year) {
    return [
      CultureHoliday("ទិវានៃក្ដីស្រឡាញ់", "Valentine's Day", DateTime(year, 2, 14)),
      CultureHoliday("ពិធីបុណ្យចូលឆ្នាំថ្មីប្រពៃណីជាតិ", "Khmer New Year", DateTime(year, 4, 14)),
      CultureHoliday("ពិធីបុណ្យចូលឆ្នាំថ្មីប្រពៃណីជាតិ", "Khmer New Year", DateTime(year, 4, 15)),
      CultureHoliday("ពិធីបុណ្យចូលឆ្នាំថ្មីប្រពៃណីជាតិ", "Khmer New Year", DateTime(year, 4, 16)),
      CultureHoliday("ព្រះរាជពិធីច្រត់ព្រះនង្គ័ល", "Royal Plowing Ceremony", DateTime(year, 5, 24)),
      CultureHoliday("ទិវាប្រកាសរដ្ឋធម្មនុញ្ញ", "Constitution Day", DateTime(year, 9, 24)),
      CultureHoliday("ពិធីបុណ្យភ្ជុំបិណ្ឌ", "Pchum Ben Festival", DateTime(year, 10, 10)),
      CultureHoliday("ទិវាឯករាជ្យជាតិ", "Independence Day", DateTime(year, 11, 9)),
      CultureHoliday("ព្រះរាជពិធីបុណ្យអុំទូក បណ្តែតប្រទីប", "Water Festival", DateTime(year, 11, 22)),
      CultureHoliday("ទិវាឆ្លងឆ្នាំសកល", "New Year's Eve", DateTime(year, 12, 31)),
    ];
  }

  static String getKhmerLunarMonth(DateTime now, {bool useKhmerDigits = true}) {
    // Cambodian traditional lunar month calculation
    const khmerMonths = [
      "មិគសិរ", "បុស្ស", "មាឃ", "ផល្គុន", "ចេត្រ", "ពិសាខ",
      "ជេស្ឋ", "អាសាឍ", "ស្រាពណ៍", "ភទ្របទ", "អស្សុជ", "កក្កដ"
    ];
    const englishMonths = [
      "Migasira", "Buss", "Meak", "Phalkun", "Chetra", "Visak",
      "Ches", "Ashadha", "Srapun", "Bhatrabath", "Assuch", "Kattika"
    ];
    int index = (now.month + 6) % 12;
    if (useKhmerDigits) {
      return "ខែ${khmerMonths[index]}";
    } else {
      return "${englishMonths[index]} Month";
    }
  }

  static DhammaQuote getDailyDhammaQuote(DateTime now) {
    final quotes = [
      DhammaQuote(
        khmer: "ចិត្តស្ងប់ នោះនាំឲ្យមានសុខ",
        english: "A calm mind brings true happiness.",
      ),
      DhammaQuote(
        khmer: "ការអត់ធ្មត់ជាដើមទុននៃជោគជ័យ",
        english: "Patience is the foundation of success.",
      ),
      DhammaQuote(
        khmer: "សន្តិភាពចាប់ផ្តើមពីក្នុងចិត្ត",
        english: "Peace begins from within the heart.",
      ),
      DhammaQuote(
        khmer: "ធ្វើល្អបានល្អ ធ្វើអាក្រក់បានអាក្រក់",
        english: "Do good and good will come to you.",
      ),
      DhammaQuote(
        khmer: "ចំណេះជាទ្រព្យជាប់កាយ",
        english: "Knowledge is a treasure that stays with you forever.",
      ),
      DhammaQuote(
        khmer: "ស្ទឹងជ្រៅស្ងាត់ជ្រងំ អ្នកប្រាជ្ញស្ងៀមស្ងាត់",
        english: "Still waters run deep; true wisdom speaks softly.",
      ),
      DhammaQuote(
        khmer: "ការឈ្នះខ្លួនឯង គឺជាជ័យជម្នះដ៏ឧត្តម",
        english: "Conquering oneself is the greatest victory.",
      ),
    ];
    return quotes[now.day % quotes.length];
  }

  static BuddhistEvent getUpcomingBuddhistEvent(DateTime now, {bool useKhmerDigits = true}) {
    return BuddhistEvent(
      nameKhmer: "អាសាឡ្ហបូជា",
      nameEnglish: "Asalha Puja",
      dateStrKhmer: "១២ សីហា ២០២៦",
      dateStrEnglish: "12 Aug 2026",
      isComing: true,
    );
  }


}

class DhammaQuote {
  final String khmer;
  final String english;
  DhammaQuote({required this.khmer, required this.english});
}

class BuddhistEvent {
  final String nameKhmer;
  final String nameEnglish;
  final String dateStrKhmer;
  final String dateStrEnglish;
  final bool isComing;

  BuddhistEvent({
    required this.nameKhmer,
    required this.nameEnglish,
    required this.dateStrKhmer,
    required this.dateStrEnglish,
    required this.isComing,
  });
}

class CultureHoliday {
  final String nameKhmer;
  final String nameEnglish;
  final DateTime date;

  CultureHoliday(this.nameKhmer, this.nameEnglish, this.date);

  String getName(bool useKhmerDigits) => useKhmerDigits ? nameKhmer : nameEnglish;
}

