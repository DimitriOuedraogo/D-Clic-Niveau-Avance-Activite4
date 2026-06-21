import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.75),
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY();
  }
}

class WeatherSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final List<String> suggestions;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.suggestions,
  });

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => widget.onSearch(),
      decoration: InputDecoration(
        hintText: 'Nom de la ville...',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.6)),
        prefixIcon:
            Icon(Icons.search, color: Colors.white.withValues(alpha:0.8)),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear,
                    color: Colors.white.withValues(alpha:0.8)),
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha:0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}

class WeatherErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const WeatherErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_off,
            size: 72, color: Colors.white.withValues(alpha:0.8)),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Réessayer'),
        ),
      ],
    ).animate().fadeIn();
  }
}

class WeatherInitialWidget extends StatelessWidget {
  const WeatherInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.public,
            size: 80, color: Colors.white.withValues(alpha:0.8)),
        const SizedBox(height: 16),
        const Text(
          'Recherchez une ville',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Entrez un nom de ville pour obtenir\nla météo en temps réel',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.white.withValues(alpha:0.7), fontSize: 14),
        ),
      ],
    ).animate().fadeIn().scale();
  }
}

class WeatherLoadingWidget extends StatelessWidget {
  const WeatherLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
        const SizedBox(height: 20),
        Text(
          'Récupération des données météo...',
          style:
              TextStyle(color: Colors.white.withValues(alpha:0.9), fontSize: 15),
        ),
      ],
    ).animate().fadeIn();
  }
}
