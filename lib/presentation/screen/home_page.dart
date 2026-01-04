import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/presentation/bloc/weather_cubit/weather_cubit.dart';
import 'package:weather/presentation/widget/custom_line_chart.dart';
import 'package:weather/presentation/widget/forecast_instance.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  String username = "Sir";

  Future<String?> _getUsername() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    return doc.data()?["username"];
  }

  void loadUser() async {
    final name = await _getUsername();
    if (name != null) {
      setState(() => username = name);
    }
  }

  Future onRefresh() async {
    await Future.wait([
      context.read<WeatherCubit>().loadWeatherData(),
      context.read<WeatherCubit>().loadForecastData(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().loadWeatherData();
    context.read<WeatherCubit>().loadForecastData();
    loadUser();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.grey.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            color: Colors.indigo,
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCurrentConditions(),
                SizedBox(height: 16),
                _buildForecast()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForecast() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.status == WeatherStatus.loading) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (state.status == WeatherStatus.loaded &&
            state.forecastData.isNotEmpty) {
          final forecastList = state.forecastData.first.list;
          final double itemWidth = 100;
          final double totalWidth = forecastList.length * itemWidth;
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "7-Day Forecast",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: forecastList
                              .map(
                                (f) => SizedBox(
                                  width: itemWidth,
                                  child: ForecastInstance(forecast: f),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          height: 50,
                          width: totalWidth,
                          child: CustomLineChart(forecast: forecastList),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "MORE DETAILS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state.status == WeatherStatus.error) {
          return const Center(
              child: Text("Failed to load forecast",
                  style: TextStyle(color: Colors.white)));
        } else {
          return const Center(
              child: Text("No data", style: TextStyle(color: Colors.white)));
        }
      },
    );
  }

  Widget _buildCurrentConditions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Conditions",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTempChart(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _weatherStat("Precipitation", "0%", Icons.water_drop),
                    SizedBox(height: 10),
                    _weatherStat("Wind", "12 km/h", Icons.air),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Today's temperature is forecast to be COOLER than yesterday",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white24),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "MORE DETAILS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherStat(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state.status == WeatherStatus.loading) {
            return const Text("Loading...", style: TextStyle(color: Colors.white));
          } else if (state.status == WeatherStatus.loaded &&
              state.weatherData.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $username",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  state.weatherData.first.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            );
          } else {
            return const Text("Weather App", style: TextStyle(color: Colors.white));
          }
        },
      ),
      actions: [
        IconButton(
          onPressed: () => FirebaseAuth.instance.signOut(),
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTempChart() {
    return SizedBox(
      height: 150,
      width: 150,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 120,
            showTicks: false,
            showLabels: false,
            axisLineStyle: AxisLineStyle(
              thickness: 20,
              cornerStyle: CornerStyle.bothCurve,
              color: Colors.white24,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 120,
                gradient: SweepGradient(
                  colors: [Colors.blue.shade300, Colors.orange.shade300],
                ),
                startWidth: 20,
                endWidth: 20,
              ),
            ],
            pointers: const <GaugePointer>[
              MarkerPointer(
                value: 83,
                markerType: MarkerType.circle,
                color: Colors.white,
                markerHeight: 20,
                markerWidth: 20,
              )
            ],
            annotations: const <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('83°',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text('Sunny',
                        style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
