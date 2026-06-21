import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  WeatherUtils._();

  static List<Color> getGradientColors(String iconCode) {
    final isNight = iconCode.endsWith('n');
    if (isNight) {
      return [const Color(0xFF0D1B2A), const Color(0xFF1B2A4A)];
    }
    final prefix = iconCode.substring(0, 2);
    switch (prefix) {
      case '01':
        return [const Color(0xFF4FC3F7), const Color(0xFF0288D1)];
      case '02':
        return [const Color(0xFF81D4FA), const Color(0xFF0277BD)];
      case '03':
      case '04':
        return [const Color(0xFF78909C), const Color(0xFF455A64)];
      case '09':
        return [const Color(0xFF546E7A), const Color(0xFF263238)];
      case '10':
        return [const Color(0xFF1565C0), const Color(0xFF0D47A1)];
      case '11':
        return [const Color(0xFF37474F), const Color(0xFF1A237E)];
      case '13':
        return [const Color(0xFFB3E5FC), const Color(0xFF81D4FA)];
      case '50':
        return [const Color(0xFF90A4AE), const Color(0xFF607D8B)];
      default:
        return [const Color(0xFF42A5F5), const Color(0xFF1565C0)];
    }
  }

  static String getWeatherEmoji(String iconCode) {
    final isNight = iconCode.endsWith('n');
    final prefix = iconCode.substring(0, 2);
    if (isNight && prefix == '01') return '🌙';
    switch (prefix) {
      case '01':
        return '☀️';
      case '02':
        return '⛅';
      case '03':
        return '🌤️';
      case '04':
        return '☁️';
      case '09':
        return '🌧️';
      case '10':
        return '🌦️';
      case '11':
        return '⛈️';
      case '13':
        return '❄️';
      case '50':
        return '🌫️';
      default:
        return '🌡️';
    }
  }

  static String formatTemp(double temp) => '${temp.round()}°C';

  static String formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

  static String formatDate(DateTime dt) =>
      DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(dt);

  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static String windDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SO', 'O', 'NO'];
    final index = ((degrees + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}
