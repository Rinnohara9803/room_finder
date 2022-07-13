import 'dart:convert';

import 'package:room_finder/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  static double temperature = 0.0;
  static String weatherMain = '';
  static int pressure = 0;
  static int humidity = 0;
  static int visibility = 0;
  static int cloudCover = 0;
  static String weatherIcon = '';

  static Widget textRow(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Row(
        children: [
          Text(
            text1,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          Text(
            text2,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> getWeatherData() async {
    try {
      var url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${SharedService.currentPosition.latitude}&lon=${SharedService.currentPosition.longitude}&appid=8a14deb41ce983d15985ba44898673d3&units=metric';
      var responseData = await http.get(
        Uri.parse(url),
      );
      var jsonData = jsonDecode(responseData.body);
      weatherMain = jsonData['weather'][0]['main'];
      temperature = jsonData['main']['temp'];
      pressure = jsonData['main']['pressure'];
      humidity = jsonData['main']['humidity'];
      visibility = jsonData['visibility'];
      cloudCover = jsonData['clouds']['all'];
      weatherIcon = jsonData['weather'][0]['icon'];
    } catch (e) {
      return Future.error('Unable to Fetch Data');
    }
  }
}
