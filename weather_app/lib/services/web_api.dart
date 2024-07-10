import 'dart:convert';
import 'dart:math';

import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart';

abstract interface class WebApi {
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  });
}

class FccApi implements WebApi {
  @override
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m');
    final result = await get(url);
    final jsonString = result.body;
    final jsonMap = jsonDecode(jsonString);
    print(jsonMap);
    final temperature = jsonMap['current']['temperature_2m'] as double;
    final weather = jsonMap['current_units']['temperature_2m'] as String;
    return Weather(
      temperature: temperature.toInt(),
      description: weather,
    );
  }
}
