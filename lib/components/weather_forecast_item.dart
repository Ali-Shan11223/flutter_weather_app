import 'package:flutter/material.dart';

class WeatherForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const WeatherForecastItem({
    super.key, required this.time, required this.icon, required this.temp
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 24,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(temp)
          ],
        ),
      ),
    );
  }
}
