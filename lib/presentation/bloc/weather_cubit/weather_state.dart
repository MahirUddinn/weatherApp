part of 'weather_cubit.dart';

enum WeatherStatus { loading, loaded, error }

class WeatherState {
  final List<ForecastModel> forecastData;
  final List<WeatherModel> weatherData;
  final WeatherStatus status;
  final String username;

  const WeatherState({
    this.forecastData = const [],
    this.weatherData = const [],
    this.status = WeatherStatus.loading,
    this.username = ""
  });

  WeatherState copyWith({
    List<ForecastModel>? forecastData,
    List<WeatherModel>? weatherData,
    WeatherStatus? status,
    String? username
  }) {
    return WeatherState(
      forecastData:  forecastData ?? this.forecastData,
      weatherData: weatherData ?? this.weatherData,
      status: status ?? this.status,
      username: username ?? this.username
    );
  }
}
