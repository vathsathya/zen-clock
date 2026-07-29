import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherInfo {
  final double temperature;
  final String conditionIcon;
  final String conditionName;
  final String locationName;

  WeatherInfo({
    required this.temperature,
    required this.conditionIcon,
    required this.conditionName,
    required this.locationName,
  });
}

class WeatherService {
  static Future<WeatherInfo> fetchLiveWeather({double lat = 11.5564, double lon = 104.9282, String location = "Phnom Penh"}) async {
    try {
      final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final currentWeather = data['current_weather'];
        final temp = (currentWeather['temperature'] as num).toDouble();
        final weatherCode = (currentWeather['weathercode'] as num).toInt();

        String icon = "☀️";
        String condition = "Clear";

        if (weatherCode == 0) {
          icon = "☀️";
          condition = "Clear Sky";
        } else if (weatherCode >= 1 && weatherCode <= 3) {
          icon = "⛅";
          condition = "Partly Cloudy";
        } else if (weatherCode >= 45 && weatherCode <= 48) {
          icon = "🌫️";
          condition = "Foggy";
        } else if (weatherCode >= 51 && weatherCode <= 67) {
          icon = "🌧️";
          condition = "Rainy";
        } else if (weatherCode >= 80 && weatherCode <= 82) {
          icon = "🌦️";
          condition = "Showers";
        } else if (weatherCode >= 95) {
          icon = "🌩️";
          condition = "Thunderstorm";
        }

        return WeatherInfo(
          temperature: temp,
          conditionIcon: icon,
          conditionName: condition,
          locationName: location,
        );
      }
    } catch (e) {
      // Fallback offline weather data
    }

    return WeatherInfo(
      temperature: 31.0,
      conditionIcon: "☀️",
      conditionName: "Sunny",
      locationName: location,
    );
  }
}
