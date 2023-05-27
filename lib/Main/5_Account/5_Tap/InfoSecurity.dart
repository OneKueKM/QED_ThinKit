import 'package:flutter/material.dart';

import 'package:flutter/services.dart'; //Haptic Feedback
import 'package:tabler_icons/tabler_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class InfoSecurity extends StatefulWidget {
  const InfoSecurity({super.key});

  @override
  State<InfoSecurity> createState() => _InfoSecurityState();
}

class _InfoSecurityState extends State<InfoSecurity> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
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
                    '개인정보 공개 설정',
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '민감한 정보는 보호할 수 있어요!',
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '전화번호 공개',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: const Icon(TablerIcons.lock, size: 22))
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '이메일 공개',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: const Icon(TablerIcons.lock_open, size: 22))
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SNS 공개',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: const Icon(TablerIcons.lock_open, size: 22))
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
