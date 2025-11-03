import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather/model/forecast_model.dart';
import 'package:weather/model/weather_model.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherState());

  static const _apiKey = "e837b65a6b647f1da18f7ec6e5260643";
  static const _baseUrl = "https://api.openweathermap.org/data/2.5";

  Future<void> loadWeatherData() async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final position = await getCurrentUserLocation();
      if (position == null) {
        emit(state.copyWith(status: WeatherStatus.error));
        return;
      }

      final url = Uri.parse(
        "$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final mappedData = WeatherModel.fromMap(data);
        emit(
          state.copyWith(
            status: WeatherStatus.loaded,
            weatherData: [mappedData],
          ),
        );
      } else {
        print("Error fetching weather: ${response.statusCode}");
        emit(state.copyWith(status: WeatherStatus.error));
      }
    } catch (e) {
      print("Error loading weather data: $e");
      emit(state.copyWith(status: WeatherStatus.error));
    }
  }

  Future<void> loadForecastData() async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final position = await getCurrentUserLocation();
      if (position == null) {
        emit(state.copyWith(status: WeatherStatus.error));
        return;
      }

      final url = Uri.parse(
        "$_baseUrl/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final mappedData = ForecastModel.fromMap(data);
        emit(
          state.copyWith(
            status: WeatherStatus.loaded,
            forecastData: [mappedData],
          ),
        );
      } else {
        print("Error fetching forecast: ${response.statusCode}");
        emit(state.copyWith(status: WeatherStatus.error));
      }
    } catch (e) {
      print("Error loading forecast data: $e");
      emit(state.copyWith(status: WeatherStatus.error));
    }
  }



  Future<Position?> getCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}
