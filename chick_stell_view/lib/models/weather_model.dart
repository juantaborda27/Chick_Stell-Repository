class Weather {
  final double temperature;
  final int humidity;
  final String description;
  final String city;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.city,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
      city: json['name'],
    );
  }
}
