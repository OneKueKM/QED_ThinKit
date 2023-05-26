import 'package:flutter/material.dart';
import '../3_Class/WeatherService.dart';

class MoonPhases extends StatefulWidget {
  const MoonPhases({super.key});

  @override
  State<MoonPhases> createState() => _MoonPhasesState();
}

class _MoonPhasesState extends State<MoonPhases> {
  WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return const Image(
        image: AssetImage('assets/images/moonicon.png'), width: 40, height: 40);
  }
}
