import 'city.dart';

class CurrentWeather {
  const CurrentWeather({
    required this.time,
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.humidityPercent,
    required this.windSpeedKmh,
    required this.weatherCode,
  });

  final DateTime time;
  final double temperatureC;
  final double apparentTemperatureC;
  final int humidityPercent;
  final double windSpeedKmh;
  final int weatherCode;
}

class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.temperatureC,
    required this.weatherCode,
  });

  final DateTime time;
  final double temperatureC;
  final int weatherCode;
}

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.minimumC,
    required this.maximumC,
    required this.weatherCode,
  });

  final DateTime date;
  final double minimumC;
  final double maximumC;
  final int weatherCode;
}

class WeatherData {
  const WeatherData({
    required this.city,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.timezone,
    required this.fetchedAt,
  });

  final City city;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final String timezone;
  final DateTime fetchedAt;
}
