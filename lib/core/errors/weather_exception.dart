class WeatherException implements Exception {
  const WeatherException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
