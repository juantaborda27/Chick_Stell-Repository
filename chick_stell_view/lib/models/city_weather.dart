

class CityWeather {
  String cityName;
  final double temperature;
  final String description;
  final String icon;


  CityWeather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });
  

  factory CityWeather.fromJson(Map<String, dynamic> json) {
    return CityWeather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}