import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  static const String _apiKey ='9de5288d810e97e5a2c43a115789a20e';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String cityName) async {
    final uri = Uri.parse(
        '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric&lang=fr');
    try {
      final response =
          await http.get(uri).timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return WeatherModel.fromJson(data);
        case 401:
          throw const WeatherException(
              'Clé API invalide. Vérifiez votre configuration.');
        case 404:
          throw WeatherException(
              'Ville "$cityName" introuvable. Vérifiez l\'orthographe.');
        case 429:
          throw const WeatherException(
              'Limite de requêtes atteinte. Réessayez plus tard.');
        default:
          throw WeatherException(
              'Erreur serveur (${response.statusCode}).');
      }
    } on WeatherException {
      rethrow;
    } on SocketException {
      throw const WeatherException('Pas de connexion Internet.');
    } catch (e) {
      throw WeatherException('Erreur inattendue : $e');
    }
  }
}
