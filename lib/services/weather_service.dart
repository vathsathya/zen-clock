import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clock_settings.dart';

class ProvinceLocation {
  final String nameKhmer;
  final String nameEnglish;
  final double lat;
  final double lon;

  const ProvinceLocation(this.nameKhmer, this.nameEnglish, this.lat, this.lon);

  String getName(bool useKhmerDigits) => useKhmerDigits ? nameKhmer : nameEnglish;
}

class WeatherDailyItem {
  final String dateStr;
  final double tempMax;
  final double tempMin;
  final String conditionIcon;
  final String conditionNameKhmer;
  final String conditionNameEnglish;
  final bool isToday;

  WeatherDailyItem({
    required this.dateStr,
    required this.tempMax,
    required this.tempMin,
    required this.conditionIcon,
    required this.conditionNameKhmer,
    required this.conditionNameEnglish,
    this.isToday = false,
  });

  String getConditionName(bool useKhmerDigits) => useKhmerDigits ? conditionNameKhmer : conditionNameEnglish;

  String getDayLabel({required bool useKhmerDigits}) {
    if (isToday) {
      return useKhmerDigits ? "ថ្ងៃនេះ" : "Today";
    }
    try {
      final dt = DateTime.parse(dateStr);
      const khmerDays = ["អាទិត្យ", "ចន្ទ", "អង្គារ", "ពុធ", "ព្រហស្បតិ៍", "សុក្រ", "សៅរ៍"];
      const engDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
      int weekdayIndex = dt.weekday % 7;
      return useKhmerDigits ? khmerDays[weekdayIndex] : engDays[weekdayIndex];
    } catch (_) {
      return dateStr;
    }
  }
}

class WeatherInfo {
  final double temperature;
  final double tempMax;
  final double tempMin;
  final int uvIndex;
  final int rainProbability;
  final String sunrise;
  final String sunset;
  final String conditionIcon;
  final String conditionNameKhmer;
  final String conditionNameEnglish;
  final String locationNameKhmer;
  final String locationNameEnglish;
  final List<WeatherDailyItem> dailyItems;

  WeatherInfo({
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.uvIndex,
    required this.rainProbability,
    required this.sunrise,
    required this.sunset,
    required this.conditionIcon,
    required this.conditionNameKhmer,
    required this.conditionNameEnglish,
    required this.locationNameKhmer,
    required this.locationNameEnglish,
    required this.dailyItems,
  });

  String getUvAdvice({required bool useKhmerDigits}) {
    if (useKhmerDigits) {
      if (uvIndex >= 11) return "🔥 យូវីកម្រិតធ្ងន់បំផុត - ចៀសវាងចេញក្រៅ";
      if (uvIndex >= 8) return "☀️ យូវីកម្រិតខ្ពស់ - គួរប្រើឆ័ត្រ/ពាក់វ៉ែនតា";
      if (uvIndex >= 6) return "⛅ យូវីកម្រិតមធ្យម - គួរការពារកម្តៅថ្ងៃ";
      if (uvIndex >= 3) return "🌤️ យូវីកម្រិតទាប - មានសុវត្ថិភាពសមរម្យ";
      return "🌙 គ្មានកាំរស្មីយូវី";
    } else {
      if (uvIndex >= 11) return "🔥 Extreme UV Level - Avoid Sun Exposure";
      if (uvIndex >= 8) return "☀️ Very High UV - Wear Sunglasses & Hat";
      if (uvIndex >= 6) return "⛅ High UV - Apply Sun Protection";
      if (uvIndex >= 3) return "🌤️ Moderate UV - Safe Conditions";
      return "🌙 Minimal UV Index";
    }
  }

  String getLocationName({required bool useKhmerDigits}) => useKhmerDigits ? locationNameKhmer : locationNameEnglish;
  String getConditionName({required bool useKhmerDigits}) => useKhmerDigits ? conditionNameKhmer : conditionNameEnglish;
}

class _WeatherCacheEntry {
  final WeatherInfo info;
  final DateTime timestamp;

  _WeatherCacheEntry(this.info, this.timestamp);

  bool get isExpired => DateTime.now().difference(timestamp).inMinutes >= 15;
}

class WeatherService {
  static final Map<ThemePreset, _WeatherCacheEntry> _cache = {};

  static const Map<ThemePreset, ProvinceLocation> provinceLocations = {
    ThemePreset.battambang: ProvinceLocation("ខេត្តបាត់ដំបង", "Battambang Province", 13.0957, 103.2022),
    ThemePreset.siemReap: ProvinceLocation("ខេត្តសៀមរាប", "Siem Reap Province", 13.3671, 103.8448),
    ThemePreset.phnomPenh: ProvinceLocation("រាជធានីភ្នំពេញ", "Phnom Penh Capital", 11.5564, 104.9282),
    ThemePreset.kep: ProvinceLocation("ខេត្តកែប", "Kep Province", 10.4819, 104.3167),
    ThemePreset.sihanoukville: ProvinceLocation("ខេត្តព្រះសីហនុ", "Sihanoukville Province", 10.6256, 103.5234),
    ThemePreset.kampot: ProvinceLocation("ខេត្តកំពត", "Kampot Province", 10.6104, 104.1815),
    ThemePreset.mondulkiri: ProvinceLocation("ខេត្តមណ្ឌលគិរី", "Mondulkiri Province", 12.4542, 107.1889),
    ThemePreset.ratanakiri: ProvinceLocation("ខេត្តរតនគិរី", "Ratanakiri Province", 13.7394, 106.9872),
    ThemePreset.preahVihear: ProvinceLocation("ខេត្តព្រះវិហារ", "Preah Vihear Province", 13.8073, 104.9811),
    ThemePreset.kampongChhnang: ProvinceLocation("ខេត្តកំពង់ឆ្នាំង", "Kampong Chhnang Province", 12.2500, 104.6667),
    ThemePreset.kampongSpeu: ProvinceLocation("ខេត្តកំពង់ស្ពឺ", "Kampong Speu Province", 11.4533, 104.5209),
    ThemePreset.kampongThom: ProvinceLocation("ខេត្តកំពង់ធំ", "Kampong Thom Province", 12.7111, 104.8883),
    ThemePreset.kampongCham: ProvinceLocation("ខេត្តកំពង់ចាម", "Kampong Cham Province", 11.9924, 105.4645),
    ThemePreset.kratie: ProvinceLocation("ខេត្តក្រចេះ", "Kratie Province", 12.4881, 106.0188),
    ThemePreset.stungTreng: ProvinceLocation("ខេត្តស្ទឹងត្រែង", "Stung Treng Province", 13.5259, 105.9683),
    ThemePreset.preyVeng: ProvinceLocation("ខេត្តព្រៃវែង", "Prey Veng Province", 11.4868, 105.3253),
    ThemePreset.svayRieng: ProvinceLocation("ខេត្តស្វាយរៀង", "Svay Rieng Province", 11.0879, 105.7994),
    ThemePreset.takeo: ProvinceLocation("ខេត្តតាកែវ", "Takeo Province", 10.9908, 104.7848),
    ThemePreset.pursat: ProvinceLocation("ខេត្តពោធិ៍សាត់", "Pursat Province", 12.5388, 103.9192),
    ThemePreset.banteayMeanchey: ProvinceLocation("ខេត្តបន្ទាយមានជ័យ", "Banteay Meanchey Province", 13.5859, 102.9737),
    ThemePreset.oddarMeanchey: ProvinceLocation("ខេត្តឧត្តរមានជ័យ", "Oddar Meanchey Province", 14.1800, 103.5200),
    ThemePreset.pailin: ProvinceLocation("ខេត្តប៉ៃលិន", "Pailin Province", 12.8489, 102.6093),
    ThemePreset.kohKong: ProvinceLocation("ខេត្តកោះកុង", "Koh Kong Province", 11.6153, 102.9838),
    ThemePreset.tboungKhmum: ProvinceLocation("ខេត្តត្បូងឃ្មុំ", "Tboung Khmum Province", 11.8892, 105.8761),
    ThemePreset.kandal: ProvinceLocation("ខេត្តកណ្តាល", "Kandal Province", 11.4500, 104.9500),
  };

  static Future<WeatherInfo> fetchLiveWeatherForTheme(ThemePreset preset) async {
    if (_cache.containsKey(preset) && !_cache[preset]!.isExpired) {
      return _cache[preset]!.info;
    }

    final loc = provinceLocations[preset] ?? const ProvinceLocation("រាជធានីភ្នំពេញ", "Phnom Penh Capital", 11.5564, 104.9282);
    final info = await fetchLiveWeather(
      lat: loc.lat,
      lon: loc.lon,
      locationKhmer: loc.nameKhmer,
      locationEnglish: loc.nameEnglish,
    );
    _cache[preset] = _WeatherCacheEntry(info, DateTime.now());
    return info;
  }

  static (String icon, String nameKhmer, String nameEnglish) _getConditionDetails(int weatherCode) {
    if (weatherCode == 0) return ("☀️", "មេឃស្រឡះល្អ", "Clear Sky");
    if (weatherCode >= 1 && weatherCode <= 3) return ("⛅", "មេឃមានពពកខ្លះ", "Partly Cloudy");
    if (weatherCode >= 45 && weatherCode <= 48) return ("🌫️", "មេឃស្រអាប់ចុះអ័ព្ទ", "Foggy / Hazy");
    if (weatherCode >= 51 && weatherCode <= 67) return ("🌧️", "មានភ្លៀងធ្លាក់", "Rainy");
    if (weatherCode >= 80 && weatherCode <= 82) return ("🌦️", "មានភ្លៀងរំភើយ", "Light Showers");
    if (weatherCode >= 95) return ("🌩️", "មានផ្គររន្ទះ", "Thunderstorm");
    return ("☀️", "មេឃស្រឡះ", "Sunny");
  }

  static Future<WeatherInfo> fetchLiveWeather({
    double lat = 11.5564,
    double lon = 104.9282,
    String locationKhmer = "រាជធានីភ្នំពេញ",
    String locationEnglish = "Phnom Penh Capital",
  }) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode,sunrise,sunset,uv_index_max,precipitation_probability_max&past_days=5&forecast_days=6&timezone=auto'
      );
      final response = await http.get(url).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final currentWeather = data['current_weather'];
        final temp = (currentWeather['temperature'] as num).toDouble();
        final weatherCode = (currentWeather['weathercode'] as num).toInt();

        final daily = data['daily'];
        final timeList = List<String>.from(daily['time'] ?? []);
        final maxTempList = List<dynamic>.from(daily['temperature_2m_max'] ?? []);
        final minTempList = List<dynamic>.from(daily['temperature_2m_min'] ?? []);
        final codeList = List<dynamic>.from(daily['weathercode'] ?? []);
        final uvList = List<dynamic>.from(daily['uv_index_max'] ?? []);
        final rainList = List<dynamic>.from(daily['precipitation_probability_max'] ?? []);
        final sunriseList = List<String>.from(daily['sunrise'] ?? []);
        final sunsetList = List<String>.from(daily['sunset'] ?? []);

        final todayStr = DateTime.now().toString().substring(0, 10);
        int todayIndex = timeList.indexWhere((t) => t == todayStr);
        if (todayIndex == -1) todayIndex = 5;

        double todayMax = todayIndex < maxTempList.length ? (maxTempList[todayIndex] as num).toDouble() : temp + 3;
        double todayMin = todayIndex < minTempList.length ? (minTempList[todayIndex] as num).toDouble() : temp - 4;
        int uv = todayIndex < uvList.length && uvList[todayIndex] != null ? (uvList[todayIndex] as num).round() : 6;
        int rain = todayIndex < rainList.length && rainList[todayIndex] != null ? (rainList[todayIndex] as num).round() : 20;

        String sunriseTime = todayIndex < sunriseList.length ? sunriseList[todayIndex].split('T').last : "05:50";
        String sunsetTime = todayIndex < sunsetList.length ? sunsetList[todayIndex].split('T').last : "18:20";

        List<WeatherDailyItem> items = [];
        for (int i = 0; i < timeList.length; i++) {
          final (icon, nameKhmer, nameEnglish) = _getConditionDetails(i < codeList.length ? (codeList[i] as num).toInt() : 0);
          items.add(WeatherDailyItem(
            dateStr: timeList[i],
            tempMax: i < maxTempList.length ? (maxTempList[i] as num).toDouble() : 32.0,
            tempMin: i < minTempList.length ? (minTempList[i] as num).toDouble() : 24.0,
            conditionIcon: icon,
            conditionNameKhmer: nameKhmer,
            conditionNameEnglish: nameEnglish,
            isToday: i == todayIndex,
          ));
        }

        final (currentIcon, currentNameKhmer, currentNameEnglish) = _getConditionDetails(weatherCode);

        return WeatherInfo(
          temperature: temp,
          tempMax: todayMax,
          tempMin: todayMin,
          uvIndex: uv,
          rainProbability: rain,
          sunrise: sunriseTime,
          sunset: sunsetTime,
          conditionIcon: currentIcon,
          conditionNameKhmer: currentNameKhmer,
          conditionNameEnglish: currentNameEnglish,
          locationNameKhmer: locationKhmer,
          locationNameEnglish: locationEnglish,
          dailyItems: items,
        );
      }
    } catch (_) {}

    return WeatherInfo(
      temperature: 31.0,
      tempMax: 33.0,
      tempMin: 25.0,
      uvIndex: 7,
      rainProbability: 15,
      sunrise: "05:50",
      sunset: "18:20",
      conditionIcon: "☀️",
      conditionNameKhmer: "មេឃស្រឡះ",
      conditionNameEnglish: "Sunny",
      locationNameKhmer: locationKhmer,
      locationNameEnglish: locationEnglish,
      dailyItems: [],
    );
  }
}
