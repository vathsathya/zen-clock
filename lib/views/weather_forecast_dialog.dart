import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clock_settings.dart';
import '../services/weather_service.dart';

class WeatherForecastDialog extends StatelessWidget {
  final WeatherInfo weather;
  final Color textColor;
  final Color bgColor;

  const WeatherForecastDialog({
    super.key,
    required this.weather,
    required this.textColor,
    required this.bgColor,
  });

  static Future<void> show(BuildContext context, WeatherInfo weather, Color textColor, Color bgColor) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WeatherForecastDialog(
        weather: weather,
        textColor: textColor,
        bgColor: bgColor,
      ),
    );
  }

  String _toKhmerDigits(String input) {
    const arabic = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const khmer = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
    String result = input;
    for (int i = 0; i < arabic.length; i++) {
      result = result.replaceAll(arabic[i], khmer[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ClockSettings>(context);
    final isKhmer = settings.useKhmerDigits;

    return Dialog(
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 680),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(weather.conditionIcon, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Text(
                      isKhmer ? 'អាកាសធាតុ ${weather.getLocationName(useKhmerDigits: true)}' : 'Weather in ${weather.getLocationName(useKhmerDigits: false)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: textColor),
                  tooltip: isKhmer ? 'បិទ' : 'Close',
                ),
              ],
            ),
            Divider(color: textColor.withOpacity(0.2), height: 24),

            // Today Insights Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInsightTile(
                        icon: '🌡️',
                        label: isKhmer ? 'សីតុណ្ហភាពថ្ងៃនេះ' : 'Today Temp',
                        value: isKhmer 
                            ? '${_toKhmerDigits(weather.temperature.toStringAsFixed(0))}°C (${_toKhmerDigits(weather.tempMin.toStringAsFixed(0))}°C - ${_toKhmerDigits(weather.tempMax.toStringAsFixed(0))}°C)'
                            : '${weather.temperature.toStringAsFixed(0)}°C (${weather.tempMin.toStringAsFixed(0)}°C - ${weather.tempMax.toStringAsFixed(0)}°C)',
                      ),
                      _buildInsightTile(
                        icon: '🌧️',
                        label: isKhmer ? 'ឱកាសភ្លៀង' : 'Rain Chance',
                        value: isKhmer ? '${_toKhmerDigits(weather.rainProbability.toString())}%' : '${weather.rainProbability}%',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInsightTile(
                        icon: '🌅',
                        label: isKhmer ? 'រះ / លិច' : 'Sunrise / Sunset',
                        value: isKhmer 
                            ? '${_toKhmerDigits(weather.sunrise)} / ${_toKhmerDigits(weather.sunset)}'
                            : '${weather.sunrise} / ${weather.sunset}',
                      ),
                      _buildInsightTile(
                        icon: '☀️',
                        label: isKhmer ? 'កាំរស្មីយូវី' : 'UV Index',
                        value: isKhmer ? 'UV ${_toKhmerDigits(weather.uvIndex.toString())}' : 'UV ${weather.uvIndex}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather.getUvAdvice(useKhmerDigits: isKhmer),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text(
              isKhmer ? '📊 ប្រវត្តិ & ការព្យាករណ៍ធាតុអាកាស' : '📊 Weather History & Forecast',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 10),

            // 11-Day Weather Forecast List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: weather.dailyItems.length,
                separatorBuilder: (context, index) => Divider(color: textColor.withOpacity(0.1), height: 1),
                itemBuilder: (context, index) {
                  final item = weather.dailyItems[index];
                  final dateDisplay = isKhmer ? _toKhmerDigits(item.dateStr) : item.dateStr;
                  final tempDisplay = isKhmer
                      ? '${_toKhmerDigits(item.tempMin.toStringAsFixed(0))}°C - ${_toKhmerDigits(item.tempMax.toStringAsFixed(0))}°C'
                      : '${item.tempMin.toStringAsFixed(0)}°C - ${item.tempMax.toStringAsFixed(0)}°C';

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: item.isToday ? textColor.withOpacity(0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(item.conditionIcon, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Text(
                              dateDisplay,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: item.isToday ? FontWeight.bold : FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                            if (item.isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: textColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isKhmer ? 'ថ្ងៃនេះ' : 'Today',
                                  style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              item.getConditionName(isKhmer),
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              tempDisplay,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightTile({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: textColor.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
