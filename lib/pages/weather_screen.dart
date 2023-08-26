import 'dart:convert';
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
  bool isLoading = false;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String countryName = 'London';
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$countryName&APPID=$weatherAPIKey'));
      final data = jsonDecode(response.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error has occured';
      }
      return data;
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   return data;
      // } else {
      //   throw 'An unexpected error has occured';
      // }
    } catch (e) {
      throw e.toString();
    }
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
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;
            final dataIndex = data['list'][0];
            final currentTemp = dataIndex['main']['temp'];
            final currentSky = dataIndex['weather'][0]['main'];
            final currentPressure = dataIndex['main']['pressure'];
            final currentHumidity = dataIndex['main']['humidity'];
            final currentWindSpeed = dataIndex['wind']['speed'];

            return Padding(
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
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  currentSky,
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
                  SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final forecastItem = data['list'][index + 1];
                            return WeatherForecastItem(
                              time: forecastItem['dt'].toString(),
                              icon: forecastItem['weather'][0]['main'] ==
                                          'Clouds' ||
                                      forecastItem['weather'][0]['main'] ==
                                          'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              temp: data['list'][index + 1]['main']['temp']
                                  .toString(),
                            );
                          })),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   physics: const BouncingScrollPhysics(),
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 5; i++)
                  //         WeatherForecastItem(
                  //             time: data['list'][i + 1]['dt'].toString(),
                  //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                  //                         'Clouds' ||
                  //                     data['list'][i + 1]['weather'][0]
                  //                             ['main'] ==
                  //                         'Rain'
                  //                 ? Icons.cloud
                  //                 : Icons.sunny,
                  //             temp: data['list'][i + 1]['main']['temp']
                  //                 .toString()),
                  //     ],
                  //   ),
                  // ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: currentHumidity.toString()),
                      AdditionalInfoItem(
                          icon: Icons.air,
                          label: 'Wind Speed',
                          value: currentWindSpeed.toString()),
                      AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: currentPressure.toString())
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
