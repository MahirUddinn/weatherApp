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

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny;
      case '01n':
        return Icons.nightlight_round;
      case '02d':
        return Icons.cloud_queue;
      case '02n':
        return Icons.cloud;
      case '03d':
      case '03n':
        return Icons.cloud;
      case '04d':
      case '04n':
        return Icons.cloudy_snowing;
      case '09d':
      case '09n':
        return Icons.grain;
      case '10d':
        return Icons.umbrella;
      case '10n':
        return Icons.umbrella_outlined;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.foggy;
      default:
        return Icons.help_outline;
    }
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
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: [
            _buildCurrentConditions(),
            _buildForecast()
          ],
        ),
      ),
    );
  }

  Widget _buildForecast() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.status == WeatherStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == WeatherStatus.loaded &&
            state.forecastData.isNotEmpty) {
          final forecastList = state.forecastData.first.list;
          final double itemWidth = 100;
          final double totalWidth = forecastList.length * itemWidth;
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Weather Forecast",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
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
                const SizedBox(height: 5),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: const Center(
                    child: Text(
                      "MORE",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state.status == WeatherStatus.error) {
          return const Center(child: Text("Failed to load forecast"));
        } else {
          return const Center(child: Text("No data"));
        }
      },
    );
  }

  Widget _buildCurrentConditions() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CURRENT CONDITIONS",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTempChart(),
              const Expanded(
                child: Column(children: [Text("Precipitation"), Text("Wind")]),
              ),
            ],
          ),
          const Divider(),
          const Text(
            "Today's temperature is forecast to be COOLER than yesterday",
          ),
          const Divider(),
          const Center(
            child: Text(
              "MORE",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepOrangeAccent,
      title: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state.status == WeatherStatus.loading) {
            return const Text("Loading...");
          } else if (state.status == WeatherStatus.loaded &&
              state.weatherData.isNotEmpty) {
            return Text(
              "Hello $username, you are in ${state.weatherData.first.name}",
            );
          } else if (state.status == WeatherStatus.error) {
            return const Text("Error loading weather");
          } else {
            return const Text("Weather App");
          }
        },
      ),
      actions: [
        IconButton(
          onPressed: () => FirebaseAuth.instance.signOut(),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildTempChart() {
    return SizedBox(
      height: 250,
      width: 250,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 120,
            showTicks: false,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 10,
                color: Colors.grey,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 10,
                endValue: 40,
                color: Colors.purple,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 40,
                endValue: 60,
                color: Colors.blue,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 60,
                endValue: 70,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 70,
                endValue: 90,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 90,
                endValue: 120,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10,
              ),
            ],
            pointers: const <GaugePointer>[
              WidgetPointer(value: 83, child: Icon(Icons.cloud, size: 30)),
            ],
            annotations: const <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text('83°', style: TextStyle(fontSize: 40)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}