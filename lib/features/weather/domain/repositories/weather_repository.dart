import '../entities/city.dart';
import '../entities/weather_data.dart';

abstract interface class WeatherRepository {
  Future<List<City>> searchCities(String query);

  Future<WeatherData> getWeather(City city);
}
