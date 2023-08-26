import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/additional_info.dart';
import '../components/weather_forecast_item.dart';
import 'package:http/http.dart' as http;

import '../services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future getCurrentWeather() async {
    String countryName = 'London';
    final result = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$countryName&APPID=$weatherAPIKey'));
    print(result.body);
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '300.67K',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Rain',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Weather Forecast',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
            ),
            const SizedBox(
              height: 14,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  WeatherForecastItem(
                      time: '3:00', icon: Icons.cloud, temp: '300.21'),
                  WeatherForecastItem(
                      time: '4:00', icon: Icons.sunny, temp: '300.58'),
                  WeatherForecastItem(
                      time: '5:00', icon: Icons.cloud, temp: '210.21'),
                  WeatherForecastItem(
                      time: '6:00', icon: Icons.sunny_snowing, temp: '150.00'),
                  WeatherForecastItem(
                      time: '7:00', icon: Icons.cloud, temp: '236.89'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Additional Information',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
            ),
            const SizedBox(
              height: 14,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                    icon: Icons.water_drop, label: 'Humidity', value: '94'),
                AdditionalInfoItem(
                    icon: Icons.air, label: 'Wind Speed', value: '7.5'),
                AdditionalInfoItem(
                    icon: Icons.beach_access, label: 'Pressure', value: '1006')
              ],
            )
          ],
        ),
      ),
    );
  }
}
