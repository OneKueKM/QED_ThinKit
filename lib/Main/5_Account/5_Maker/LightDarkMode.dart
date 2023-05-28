import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class LightDarkMode extends StatefulWidget {
  const LightDarkMode({super.key});

  @override
  State<LightDarkMode> createState() => _LightDarkModeState();
}

class _LightDarkModeState extends State<LightDarkMode> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 50,
      child: IconButton(
        icon: const Icon(TablerIcons.moon_stars),
        color: Colors.black,
        iconSize: 22,
        onPressed: () {},
      ),
    );
  }
}
