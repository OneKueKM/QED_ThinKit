class Weather {
  final String condition;

  Weather({this.condition = 'Sunny'});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['current']['condition']['text'],
    );
  }
}
