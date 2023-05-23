import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart'; //Haptic Feedback
import 'package:tabler_icons/tabler_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class NotificationTap extends StatefulWidget {
  const NotificationTap({super.key});

  @override
  State<NotificationTap> createState() => _NotificationTapState();
}

class _NotificationTapState extends State<NotificationTap> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
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
                  '알림',
                  style: TextStyle(
                      fontFamily: 'SFProText',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                const SizedBox(height: 5),
                const Text(
                  '여러가지 알림을 켜고 끌 수 있어요.',
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
                        Text(
                          '앱 전체 알림 설정',
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
                              '설정',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 211, 0, 0)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              '로그인 알림',
                              style: TextStyle(
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: 240,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              strutStyle: const StrutStyle(fontSize: 11),
                              text: const TextSpan(
                                  text: '새로운 로그인이 발생할 때마다 푸시알림으로 알려드립니다.',
                                  style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Color.fromARGB(255, 105, 105, 105),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                  )),
                            ))
                          ],
                        ),
                      ),
                    ],
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
                              : const Color.fromARGB(255, 211, 0, 0),
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
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              '전화요청 알림',
                              style: TextStyle(
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: 240,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              strutStyle: const StrutStyle(fontSize: 11),
                              text: const TextSpan(
                                  text: '상대방이 내게 전화를 요청하면 푸시알림으로 알려드립니다.',
                                  style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Color.fromARGB(255, 105, 105, 105),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                  )),
                            ))
                          ],
                        ),
                      ),
                    ],
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
                              : const Color.fromARGB(255, 211, 0, 0),
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
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              '이벤트 및 마케팅 알림',
                              style: TextStyle(
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: 240,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              strutStyle: const StrutStyle(fontSize: 11),
                              text: const TextSpan(
                                  text:
                                      'Thin Kit에서 진행되는 이벤트 및 마케팅에 관한 알림을 보내드립니다.',
                                  style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Color.fromARGB(255, 105, 105, 105),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                  )),
                            ))
                          ],
                        ),
                      ),
                    ],
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
                              : const Color.fromARGB(255, 211, 0, 0),
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
          ],
        ),
      ),
    );
  }
}
