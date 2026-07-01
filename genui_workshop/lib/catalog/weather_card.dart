import 'package:flutter/material.dart';
import 'package:genui_workshop/genui_utils.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'dart:io';

import 'dart:convert';
import 'fake_forecast.dart';

final forecastSchema = S.object(
  properties: {
    'area_name': S.string(),
    //"flags": S.object(),
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
                mainAxisAlignment: .end,
                children: [
                  Text(
                    "Observed at ${currentCondition["observation_time"]}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Header: Icon and City Name
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

              // Temperature Display
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

              // Low Temp row
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

              // Weather Condition
              Text("${data['weatherDesc']}", style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}