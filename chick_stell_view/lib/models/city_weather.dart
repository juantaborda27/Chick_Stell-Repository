

class CityWeather {
  String cityName;
  final double temperature;
  final String description;
  final String icon;
  //NEW
  final double lon;
  final double lat;
  final double temMax;
  final double temMin;
  final double pressure;
  final double humidity;
  final String country;


  CityWeather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    //NEW
    this.lon = 0.0,
    this.lat = 0.0,
    this.temMax = 0.0,
    this.temMin = 0.0,
    this.pressure = 0.0,
    this.humidity = 0.0,
    this.country = '',
  });
  

  factory CityWeather.fromJson(Map<String, dynamic> json) {
    return CityWeather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      lon: json['coord']['lon'].toDouble(),
      lat: json['coord']['lat'].toDouble(),
      temMin: json['main']['temp_min'].toDouble(),
      temMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      country: json['sys']['country'],
    );
  }
}