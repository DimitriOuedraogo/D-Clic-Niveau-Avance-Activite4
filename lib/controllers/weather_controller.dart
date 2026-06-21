import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherController extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _weather;
  String _errorMessage = '';
  final List<String> _searchHistory = [];

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasData => _status == WeatherStatus.success && _weather != null;
  bool get hasError => _status == WeatherStatus.error;
  bool get isInitial => _status == WeatherStatus.initial;

  Future<void> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) return;

    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      final result = await _service.fetchWeather(cityName.trim());
      _weather = result;
      _status = WeatherStatus.success;
      _addToHistory(cityName.trim());
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  void _addToHistory(String city) {
    _searchHistory.remove(city);
    _searchHistory.insert(0, city);
    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }
  }

  void reset() {
    _status = WeatherStatus.initial;
    _weather = null;
    _errorMessage = '';
    notifyListeners();
  }
}
