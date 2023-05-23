import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Weather.dart';
import 'package:flutter/material.dart';

class WeatherService{
  Future <Weather> getWeatherData(String place) async{
    //078e88f763b241d1bbf130359230702

    try{
      final queryParameters = {
        'key': '078e88f763b241d1bbf130359230702',
        'q' : place,
      };
      final uri = Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      debugPrint(uri.toString());
      final response = await http.get(uri);
      if(response.statusCode == 200){
        return Weather.fromJson(jsonDecode(response.body));
      } else{
        throw Exception('Can not get weather');
      }
    } catch(e){
      rethrow;
    }
  }
}