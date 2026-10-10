class City {
  const City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.countryCode,
    this.region,
    this.timezone,
  });

  static const santiago = City(
    id: '3871336',
    name: 'Santiago',
    latitude: -33.45694,
    longitude: -70.64827,
    country: 'Chile',
    countryCode: 'CL',
    region: 'Santiago Metropolitan',
    timezone: 'America/Santiago',
  );

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? countryCode;
  final String? region;
  final String? timezone;

  String get subtitle {
    final values = <String>{
      if (region != null && region!.trim().isNotEmpty) region!.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    };
    return values.join(', ');
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'country': country,
    'countryCode': countryCode,
    'region': region,
    'timezone': timezone,
  };

  factory City.fromJson(Map<String, Object?> json) => City(
    id: json['id']! as String,
    name: json['name']! as String,
    latitude: (json['latitude']! as num).toDouble(),
    longitude: (json['longitude']! as num).toDouble(),
    country: json['country']! as String,
    countryCode: json['countryCode'] as String?,
    region: json['region'] as String?,
    timezone: json['timezone'] as String?,
  );

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
