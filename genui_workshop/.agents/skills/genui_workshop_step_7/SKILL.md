---
name: genui_workshop_step_7
description: Execute Step 7 of the GenUI Workshop, creating the weather card widget and fake forecast data.
---

# GenUI Workshop - Step 7

**Goal**: Execute Step 7 of the GenUI workshop.

**Instructions**:
Use your code editing tools to create the weather card catalog widget, fake forecast data, and update the app's configuration.

1. Create `lib/catalog/weather_card.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final forecastSchema = S.object(
  properties: {
    'area_name': S.string(),
    'current_condition': S.object(
      properties: {
        "temp_C": S.number(),
        "temp_F": S.number(),
        "humidity": S.number(),
        "observation_time": S.string(),
      },
    ),
    'weatherDesc': S.string(),
    'weatherIconUrl': S.string(),
  },
);

final weatherCard = CatalogItem(
  name: 'WeatherCard',
  dataSchema: forecastSchema,
  widgetBuilder: (itemContext) {
    return WeatherCard(data: itemContext.data as Map<String, Object?>);
  },
);

class WeatherCard extends StatelessWidget {
  final Map<String, Object?> data;
  const WeatherCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentCondition = data["current_condition"] as Map<String, Object?>;
    return Container(
      width: 500,
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Observed at ${currentCondition["observation_time"]}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.network(
                    data["weatherIconUrl"].toString(),
                    errorBuilder: (context, err, trace) {
                        return Icon(Icons.wb_sunny, size: 32,);
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    data["area_name"].toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    currentCondition["temp_C"]!.toString(),
                    style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "°C",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    currentCondition['temp_F'].toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "°F",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("${data['weatherDesc']}", style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
```

2. Create `lib/catalog/fake_forecast.dart`:
```dart
var fakeForecast = {
  'area_name': 'Baltimore (Mount Clare)',
  'current_condition': {
    'temp_C': 22,
    'temp_F': 72,
    'humidity': 61,
    'observation_time': '02:25 PM',
  },
  'weatherDesc': ' Sunny',
  'weatherIconUrl':
      'https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0001_sunny.png',
};
```

3. Edit `lib/main.dart` to import the new catalog item and add it to `BasicCatalogItems.asCatalog().copyWith(...)`:
Add this import at the top:
```dart
import 'package:genui_workshop/catalog/weather_card.dart';
```
And in `initState`, modify `catalog = BasicCatalogItems.asCatalog().copyWith(newItems: [weatherInput]);` to include the `weatherCard`:
```dart
    catalog = BasicCatalogItems.asCatalog().copyWith(
      newItems: [weatherInput, weatherCard],
    );
```
