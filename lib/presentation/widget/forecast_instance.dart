import 'package:flutter/material.dart';
import 'package:weather/model/forecast_model.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;


class ForecastInstance extends StatelessWidget {
  const ForecastInstance({super.key, required this.forecast});

  final ListElement forecast;

  String _getTime(int dt) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      dt * 1000,
      isUtc: true,
    ).toLocal();
    return DateFormat('h a').format(dateTime);
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny; // Clear day
      case '01n':
        return Icons.nights_stay; // Clear night
      case '02d':
        return Icons.cloud_queue; // Few clouds day
      case '02n':
        return Icons.cloud; // Few clouds night
      case '03d':
      case '03n':
        return Icons.cloud; // Scattered clouds
      case '04d':
      case '04n':
        return Icons.cloud_outlined; // Broken clouds
      case '09d':
      case '09n':
        return Icons.grain; // Shower rain
      case '10d':
      case '10n':
        return Icons.umbrella; // Rain
      case '11d':
      case '11n':
        return Icons.flash_on; // Thunderstorm
      case '13d':
      case '13n':
        return Icons.ac_unit; // Snow
      case '50d':
      case '50n':
        return Icons.cloud; // Mist/Fog (no foggy icon)
      default:
        return Icons.help_outline; // Unknown
    }
  }


  String _getForecastTemp(double temp) {
    double fahrenheit = (temp - 273.15) * 9 / 5 + 32;
    return "${fahrenheit.toStringAsFixed(1)}°F";
  }

  Transform _getWindDirectionIcon(deg){
    return Transform.rotate(
      angle: deg * (math.pi / 180),
      child: Icon(
        Icons.arrow_upward_rounded,
        color: Colors.amber,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getTime(forecast.dt),
          ),
          SizedBox(height: 10),
          Icon(
            _getWeatherIcon(forecast.weather.first.icon),
            size: 30,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(_getForecastTemp(forecast.main.temp)),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getWindDirectionIcon(forecast.wind.deg),
              Text("${forecast.wind.speed}mph"),
            ],
          ),
        ],
      ),
    );
  }
}
