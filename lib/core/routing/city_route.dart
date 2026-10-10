import '../../features/weather/domain/entities/city.dart';

abstract final class CityRoute {
  static String location(City city) {
    return Uri(
      path: '/city/${Uri.encodeComponent(city.id)}',
      queryParameters: {
        'name': city.name,
        'lat': city.latitude.toString(),
        'lon': city.longitude.toString(),
        'country': city.country,
        if (city.countryCode != null) 'countryCode': city.countryCode,
        if (city.region != null) 'region': city.region,
        if (city.timezone != null) 'timezone': city.timezone,
      },
    ).toString();
  }

  static City? parse(String id, Map<String, String> query) {
    final latitude = double.tryParse(query['lat'] ?? '');
    final longitude = double.tryParse(query['lon'] ?? '');
    final name = query['name'];
    final country = query['country'];
    if (latitude == null ||
        longitude == null ||
        name == null ||
        country == null) {
      return null;
    }
    return City(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      country: country,
      countryCode: query['countryCode'],
      region: query['region'],
      timezone: query['timezone'],
    );
  }
}
