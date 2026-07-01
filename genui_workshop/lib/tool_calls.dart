import 'package:firebase_ai/firebase_ai.dart';

final fetchWeatherGeocodeTool = FunctionDeclaration(
  'fetchWeather',
  'Retrieves the weather for the current date and returns geocoded location data',
  parameters: {
    'location': Schema.string(
      description: 'The location for which to retrieve the weather',
    ),
    'date': Schema.string(
      description:
          'The date for which to retrieve the weather',
    ),
  },
);