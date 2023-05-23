import 'package:flutter/material.dart';
import '../3_Class/WeatherService.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherService().getWeatherData('Incheon'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var weather = snapshot.data;
          if (weather != null) {
            switch (weather.condition) {
              case 'Sunny':
                return const Image(
                  image: AssetImage('assets/images/sunny.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Clear':
                return const Image(
                  image: AssetImage('assets/images/sunny.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Partly Cloudy':
                return const Image(
                  image: AssetImage('assets/images/cloud_only.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Cloudy':
                return const Image(
                  image: AssetImage('assets/images/cloud_only.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Overcast':
                return const Image(
                  image: AssetImage('assets/images/cloud_only.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Mist':
                return const Image(
                  image: AssetImage('assets/images/cloud_only.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy rain possible':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy snow possible':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy sleet possible':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy freezing drizzle possible':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Thundery outbreaks possible':
                return const Image(
                  image: AssetImage('assets/images/thunder.png'),
                  width: 40,
                  height: 40,
                );
              case 'Blowing snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Blizzard':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Fog':
                return const Image(
                  image: AssetImage('assets/images/cloud_only.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Freezing fog':
                return const Image(
                  image: AssetImage('assets/images/cloud_only.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy light drizzle':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Light drizzle':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Freezing drizzle':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Heavy freezing drizzle':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy light rain"':
                return const Image(
                  image: AssetImage('assets/images/cloud_light_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Light rain':
                return const Image(
                  image: AssetImage('assets/images/cloud_light_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate rain at times':
                return const Image(
                  image: AssetImage('assets/images/cloud_light_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate rain':
                return const Image(
                  image: AssetImage('assets/images/cloud_light_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Heavy rain at times':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Heavy rain':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Light freezing rain':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy freezing rain':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Light sleet':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy sleet showers':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy light snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Light snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy moderate snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy heavy snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Heavy snow':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Ice pellets':
                return const Image(
                  image: AssetImage('assets/images/ice_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Light rain shower':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy rain shower':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Torrential rain shower':
                return const Image(
                  image: AssetImage('assets/images/cloud_rain.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Light sleet showers':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Light snow showers':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy snow showers':
                return const Image(
                  image: AssetImage('assets/images/cloud_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Light showers of ice pellets':
                return const Image(
                  image: AssetImage('assets/images/ice_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy showers of ice pellets':
                return const Image(
                  image: AssetImage('assets/images/ice_snow.png'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy light rain with thunder':
                return const Image(
                  image: AssetImage('assets/images/cloud_thunder.png'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy rain with thunder':
                return const Image(
                  image: AssetImage('assets/images/rainnythundercloud.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Patchy light snow with thunder':
                return const Image(
                  image: AssetImage('assets/images/rainnythundercloud.gif'),
                  width: 40,
                  height: 40,
                );
              case 'Moderate or heavy snow with thunder':
                return const Image(
                  image: AssetImage('assets/images/rainnythundercloud.gif'),
                  width: 40,
                  height: 40,
                );

              default:
                return const Image(
                    image: AssetImage('assets/images/rainnythundercloud.gif'),
                    width: 40,
                    height: 40);
            }
          } else {
            return const SizedBox(); // Return an empty widget if the weather data is null
          }
        } else {
          return const CircularProgressIndicator(
            color: Colors.white,
          ); // Return a progress indicator while the data is being fetched
        }
      },
    );
  }
}
