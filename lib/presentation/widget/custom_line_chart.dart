import 'package:flutter/material.dart';
import 'package:weather/model/forecast_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({super.key, required this.forecast});

  final List<ListElement> forecast;

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  double _convertToFahrenheit(double kelvin) {
    return (kelvin - 273.15) * 9 / 5 + 32;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.forecast.isEmpty) {
      return const SizedBox(height: 50, child: Center(child: Text("No data")));
    }

    final allTemps = widget.forecast
        .map((e) => _convertToFahrenheit(e.main.temp))
        .toList();

    final minTemp = allTemps.reduce(min);
    final maxTemp = allTemps.reduce(max);

    final double minY = minTemp - 10;
    final double maxY = maxTemp + 10;

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        lineBarsData: [_buildLineChartBarData()],
        titlesData: _buildTilesData(),
        minY: minY,
        maxY: maxY,
      ),
    );
  }

  LineChartBarData _buildLineChartBarData() {
    final spots = widget.forecast.asMap().entries.map((entry) {
      final fahrenheitTemp = _convertToFahrenheit(entry.value.main.temp);
      return FlSpot(entry.key.toDouble(), fahrenheitTemp);
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.red,
      barWidth: 3,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }

  FlTitlesData _buildTilesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          minIncluded: false,
          reservedSize: 50,
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('${value.toStringAsFixed(0)}°F');
          },
        ),
      ),
    );
  }
}
