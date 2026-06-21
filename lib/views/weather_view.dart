import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_widgets.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with TickerProviderStateMixin {
  late final TextEditingController _cityController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(BuildContext context) async {
    final controller =
        Provider.of<WeatherController>(context, listen: false);
    await controller.fetchWeather(_cityController.text);
    if (controller.hasData) {
      _fadeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherController>(
      builder: (context, controller, _) {
        final iconCode =
            controller.weather?.iconCode ?? '01d';
        final gradientColors =
            WeatherUtils.getGradientColors(iconCode);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  title: const Text(
                    '✨ Application Météo',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    if (controller.hasData)
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () => _onSearch(context),
                      ),
                    IconButton(
                      icon: const Icon(Icons.restart_alt,
                          color: Colors.white),
                      onPressed: controller.reset,
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      WeatherSearchBar(
                        controller: _cityController,
                        onSearch: () => _onSearch(context),
                        suggestions: controller.searchHistory,
                      ),
                      const SizedBox(height: 12),
                      if (controller.searchHistory.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          children: controller.searchHistory
                              .map(
                                (city) => ActionChip(
                                  label: Text(
                                    city,
                                    style: const TextStyle(
                                      color: Color(0xFF0288D1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  side: BorderSide.none,
                                  onPressed: () {
                                    _cityController.text = city;
                                    _onSearch(context);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      ElevatedButton.icon(
                        onPressed: () => _onSearch(context),
                        icon: const Icon(Icons.cloud_download,
                            color: Color(0xFF0288D1)),
                        label: const Text(
                          'Obtenir la météo',
                          style: TextStyle(
                            color: Color(0xFF0288D1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 480,
                        child: _buildStatusWidget(controller),
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusWidget(WeatherController controller) {
    switch (controller.status) {
      case WeatherStatus.initial:
        return const WeatherInitialWidget();
      case WeatherStatus.loading:
        return const WeatherLoadingWidget();
      case WeatherStatus.error:
        return WeatherErrorWidget(
          message: controller.errorMessage,
          onRetry: () => _onSearch(context),
        );
      case WeatherStatus.success:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _WeatherDataView(weather: controller.weather!),
        );
    }
  }
}

class _WeatherDataView extends StatelessWidget {
  final WeatherModel weather;

  const _WeatherDataView({required this.weather});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${weather.cityName}, ${weather.country}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  WeatherUtils.formatDate(weather.updatedAt),
                  style: TextStyle(
                      color: Colors.white.withValues(alpha:0.75), fontSize: 13),
                ),
                const SizedBox(height: 12),
                Text(
                  WeatherUtils.getWeatherEmoji(weather.iconCode),
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 8),
                Text(
                  WeatherUtils.formatTemp(weather.temperature),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ressenti ${WeatherUtils.formatTemp(weather.feelsLike)}',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha:0.8), fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  WeatherUtils.capitalize(weather.description),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '↓ ${WeatherUtils.formatTemp(weather.tempMin)}   ↑ ${WeatherUtils.formatTemp(weather.tempMax)}',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha:0.85), fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              WeatherDetailCard(
                icon: Icons.water_drop,
                label: 'Humidité',
                value: '${weather.humidity}%',
                iconColor: Colors.lightBlueAccent,
              ),
              WeatherDetailCard(
                icon: Icons.air,
                label: 'Vent',
                value:
                    '${weather.windSpeed.round()} km/h ${WeatherUtils.windDirection(weather.windDegree)}',
                iconColor: Colors.white,
              ),
              WeatherDetailCard(
                icon: Icons.speed,
                label: 'Pression',
                value: '${weather.pressure} hPa',
                iconColor: Colors.orangeAccent,
              ),
              WeatherDetailCard(
                icon: Icons.visibility,
                label: 'Visibilité',
                value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                iconColor: Colors.greenAccent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('🌅', style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      WeatherUtils.formatTime(weather.sunrise),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Lever',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha:0.7), fontSize: 12),
                    ),
                  ],
                ),
                Container(
                    width: 1,
                    height: 50,
                    color: Colors.white.withValues(alpha:0.3)),
                Column(
                  children: [
                    const Text('🌇', style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      WeatherUtils.formatTime(weather.sunset),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Coucher',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha:0.7), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
