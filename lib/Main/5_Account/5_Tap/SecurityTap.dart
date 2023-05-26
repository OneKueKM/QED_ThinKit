import 'package:flutter/material.dart';

import 'package:flutter/services.dart'; //Haptic Feedback
import 'package:tabler_icons/tabler_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class SecurityTap extends StatefulWidget {
  const SecurityTap({super.key});

  @override
  State<SecurityTap> createState() => _SecurityTapState();
}

class _SecurityTapState extends State<SecurityTap> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 222, 222, 222),
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                ),
                const SizedBox(height: 10),
                const Text(
                  '보안',
                  style: TextStyle(
                      fontFamily: 'SFProText',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                const SizedBox(height: 5),
                const Text(
                  '보안을 통해서 소중한 정보를 안전하게 지키세요.',
                  style: TextStyle(
                      fontFamily: 'SFProText',
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Icon(
                            TablerIcons.sort_0_9,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'PIN 비밀번호 설정',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 25,
                        width: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '변경',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 40, 72, 255)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Icon(
                            TablerIcons.face_id,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Face ID 설정',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedToggleSwitch<int>.size(
                          height: 25,
                          current: value,
                          values: const [0, 1],
                          iconOpacity: 0.7,
                          animationDuration: const Duration(milliseconds: 300),
                          indicatorSize: const Size(22, double.infinity),
                          borderWidth: 2.0,
                          borderColor: const Color.fromARGB(255, 239, 239, 239),
                          innerColor: const Color.fromARGB(255, 239, 239, 239),
                          colorBuilder: (i) => i.isEven
                              ? Colors.white
                              : const Color.fromARGB(255, 77, 193, 81),
                          onChanged: (i) {
                            HapticFeedback.mediumImpact();
                            setState(() => value = i);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Icon(
                            TablerIcons.fingerprint,
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Touch ID 설정',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedToggleSwitch<int>.size(
                          height: 25,
                          current: value,
                          values: const [0, 1],
                          iconOpacity: 0.7,
                          animationDuration: const Duration(milliseconds: 300),
                          indicatorSize: const Size(22, double.infinity),
                          borderWidth: 2.0,
                          borderColor: const Color.fromARGB(255, 239, 239, 239),
                          innerColor: const Color.fromARGB(255, 239, 239, 239),
                          colorBuilder: (i) => i.isEven
                              ? Colors.white
                              : const Color.fromARGB(255, 77, 193, 81),
                          onChanged: (i) {
                            HapticFeedback.mediumImpact();
                            setState(() => value = i);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Icon(
                            TablerIcons.planet,
                            size: 27,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '해외 IP 로그인 차단',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedToggleSwitch<int>.size(
                          height: 25,
                          current: value,
                          values: const [0, 1],
                          iconOpacity: 0.7,
                          animationDuration: const Duration(milliseconds: 300),
                          indicatorSize: const Size(22, double.infinity),
                          borderWidth: 2.0,
                          borderColor: const Color.fromARGB(255, 239, 239, 239),
                          innerColor: const Color.fromARGB(255, 239, 239, 239),
                          colorBuilder: (i) => i.isEven
                              ? Colors.white
                              : const Color.fromARGB(255, 77, 193, 81),
                          onChanged: (i) {
                            HapticFeedback.mediumImpact();
                            setState(() => value = i);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
