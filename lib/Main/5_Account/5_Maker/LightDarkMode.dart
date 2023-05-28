import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

class LightDarkMode extends StatefulWidget {
  const LightDarkMode({super.key});

  @override
  State<LightDarkMode> createState() => _LightDarkModeState();
}

class _LightDarkModeState extends State<LightDarkMode> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: AnimatedIconButton(
          duration: const Duration(milliseconds: 500),
          onPressed: () => print('Dark Mode'),
          icons: [
            AnimatedIconItem(
              icon: const Icon(TablerIcons.moon_filled,
                  color: Color.fromARGB(255, 195, 195, 195), size: 24),
              onPressed: () => print('Light Mode'),
            ),
            const AnimatedIconItem(
              icon: Icon(TablerIcons.sun_filled,
                  color: Color.fromARGB(255, 195, 195, 195), size: 24),
            ),
          ],
        ));
  }
}
