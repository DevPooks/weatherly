import '../../../weather/domain/entities/city.dart';
import '../../../weather/domain/entities/weather_data.dart';

class WeatherDataModel {
  const WeatherDataModel({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.timezone,
  });

  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final String timezone;

  factory WeatherDataModel.fromOpenMeteo(Map<String, Object?> json) {
    final currentJson = _map(json, 'current');
    final hourlyJson = _map(json, 'hourly');
    final dailyJson = _map(json, 'daily');
    final current = CurrentWeather(
      time: DateTime.parse(currentJson['time']! as String),
      temperatureC: _number(currentJson, 'temperature_2m'),
      apparentTemperatureC: _number(currentJson, 'apparent_temperature'),
      humidityPercent: _number(currentJson, 'relative_humidity_2m').round(),
      windSpeedKmh: _number(currentJson, 'wind_speed_10m'),
      weatherCode: _number(currentJson, 'weather_code').round(),
    );

    final hourlyTimes = _strings(hourlyJson, 'time');
    final hourlyTemperatures = _numbers(hourlyJson, 'temperature_2m');
    final hourlyCodes = _numbers(hourlyJson, 'weather_code');
    final allHourly = List.generate(
      [
        hourlyTimes.length,
        hourlyTemperatures.length,
        hourlyCodes.length,
      ].reduce((left, right) => left < right ? left : right),
      (index) => HourlyForecast(
        time: DateTime.parse(hourlyTimes[index]),
        temperatureC: hourlyTemperatures[index],
        weatherCode: hourlyCodes[index].round(),
      ),
    );
    var nextHourly = allHourly
        .where(
          (forecast) => !forecast.time.isBefore(
            DateTime(
              current.time.year,
              current.time.month,
              current.time.day,
              current.time.hour,
            ),
          ),
        )
        .take(24)
        .toList(growable: false);
    if (nextHourly.isEmpty) {
      nextHourly = allHourly.take(24).toList(growable: false);
    }

    final dailyTimes = _strings(dailyJson, 'time');
    final dailyMinimums = _numbers(dailyJson, 'temperature_2m_min');
    final dailyMaximums = _numbers(dailyJson, 'temperature_2m_max');
    final dailyCodes = _numbers(dailyJson, 'weather_code');
    final dailyLength = [
      dailyTimes.length,
      dailyMinimums.length,
      dailyMaximums.length,
      dailyCodes.length,
    ].reduce((left, right) => left < right ? left : right);
    final daily = List.generate(
      dailyLength,
      (index) => DailyForecast(
        date: DateTime.parse(dailyTimes[index]),
        minimumC: dailyMinimums[index],
        maximumC: dailyMaximums[index],
        weatherCode: dailyCodes[index].round(),
      ),
    );

    return WeatherDataModel(
      current: current,
      hourly: nextHourly,
      daily: daily,
      timezone: (json['timezone'] as String?) ?? 'Local time',
    );
  }

  WeatherData toEntity(City city) => WeatherData(
    city: city,
    current: current,
    hourly: hourly,
    daily: daily,
    timezone: timezone,
    fetchedAt: DateTime.now(),
  );
}

Map<String, Object?> _map(Map<String, Object?> json, String key) =>
    (json[key]! as Map).cast<String, Object?>();

double _number(Map<String, Object?> json, String key) =>
    (json[key]! as num).toDouble();

List<double> _numbers(Map<String, Object?> json, String key) =>
    (json[key]! as List).cast<num>().map((value) => value.toDouble()).toList();

List<String> _strings(Map<String, Object?> json, String key) =>
    (json[key]! as List).cast<String>();
