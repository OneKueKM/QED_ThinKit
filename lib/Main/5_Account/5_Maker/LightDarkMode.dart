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
    return InkWell(
        splashColor: Colors.transparent, // 터치 효과의 색상을 투명으로 설정
        highlightColor: Colors.transparent, // 터치 효과의 하이라이트 색상을 투명으로 설정
        enableFeedback: false,
        onTap: () {
          // 클릭 이벤트 처리
        },
        child: AnimatedIconButton(
          duration: const Duration(milliseconds: 500),
          onPressed: () => print('all icons pressed'),
          icons: [
            AnimatedIconItem(
              icon: const Icon(TablerIcons.moon_filled,
                  color: Color.fromARGB(255, 195, 195, 195), size: 24),
              onPressed: () => print('add pressed'),
            ),
            const AnimatedIconItem(
              icon: Icon(TablerIcons.sun_filled,
                  color: Color.fromARGB(255, 195, 195, 195), size: 24),
            ),
          ],
        ));
  }
}
