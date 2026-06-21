# Application Météo Flutter

Application mobile Flutter qui affiche la météo en temps réel en consommant l'API OpenWeatherMap. Développée en architecture MVC avec Provider pour la gestion d'état.

---

## Fonctionnalités

- Recherche météo par nom de ville
- Affichage de la température, ressenti, min/max
- Humidité, pression, vitesse et direction du vent, visibilité
- Heures de lever et coucher du soleil
- Historique des 5 dernières recherches (chips cliquables)
- Dégradé de fond dynamique selon les conditions météo (jour/nuit)
- Emojis météo contextuels
- Date et heure en français
- Animations d'entrée avec `flutter_animate`

---

## Architecture

```
lib/
├── main.dart                        # Point d'entrée, Provider, thème
├── models/
│   └── weather_model.dart           # Modèle de données (fromJson)
├── services/
│   └── weather_service.dart         # Appels HTTP + gestion d'erreurs
├── controllers/
│   └── weather_controller.dart      # Logique métier, ChangeNotifier
├── utils/
│   └── weather_utils.dart           # Fonctions utilitaires statiques
├── widgets/
│   └── weather_widgets.dart         # Widgets réutilisables
└── views/
    └── weather_view.dart            # Interface utilisateur principale
```

---

## Technologies utilisées

| Package | Version | Usage |
|---|---|---|
| `http` | ^1.6.0 | Requêtes HTTP vers OpenWeatherMap |
| `provider` | ^6.1.5+1 | Gestion d'état (MVC) |
| `intl` | ^0.20.2 | Formatage des dates en français |
| `flutter_animate` | ^4.5.2 | Animations d'interface |

---

## Installation

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd activite_acces_api
```

### 2. Obtenir une clé API OpenWeatherMap

1. Créer un compte sur [openweathermap.org](https://openweathermap.org)
2. Aller dans **My API Keys** et copier la clé

### 3. Configurer la clé API

Dans `lib/services/weather_service.dart`, remplacer la valeur de `_apiKey` :

```dart
static const String _apiKey = 'VOTRE_CLE_API_ICI';
```

### 4. Installer les dépendances et lancer

```bash
flutter pub get
flutter run
```

---

## Gestion des erreurs

| Code HTTP | Message affiché |
|---|---|
| 401 | Clé API invalide |
| 404 | Ville introuvable |
| 429 | Limite de requêtes atteinte |
| Autre | Erreur serveur (code) |
| Pas de réseau | Pas de connexion Internet |

---

## Dégradés de fond selon la météo

| Condition | Couleurs |
|---|---|
| Nuit | Bleu nuit profond |
| Ciel dégagé | Bleu ciel |
| Nuageux | Gris bleuté |
| Pluie | Bleu foncé |
| Orage | Gris anthracite |
| Neige | Bleu glacé |
| Brume | Gris |

---

## Activité n°4 — Niveau Avancé
Formation développement mobile Flutter
