import '../../domain/entities/city.dart';

class CityModel {
  const CityModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.countryCode,
    this.region,
    this.timezone,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? countryCode;
  final String? region;
  final String? timezone;

  factory CityModel.fromOpenMeteo(Map<String, Object?> json) {
    final latitude = (json['latitude']! as num).toDouble();
    final longitude = (json['longitude']! as num).toDouble();
    return CityModel(
      id:
          (json['id'] as num?)?.toInt().toString() ??
          '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}',
      name: json['name']! as String,
      latitude: latitude,
      longitude: longitude,
      country:
          (json['country'] as String?) ??
          (json['country_code'] as String?) ??
          'Unknown country',
      countryCode: json['country_code'] as String?,
      region: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  City toEntity() => City(
    id: id,
    name: name,
    latitude: latitude,
    longitude: longitude,
    country: country,
    countryCode: countryCode,
    region: region,
    timezone: timezone,
  );
}
