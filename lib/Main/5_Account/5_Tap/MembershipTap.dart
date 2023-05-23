import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart'; //Haptic Feedback
import 'package:tabler_icons/tabler_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class MembershipTap extends StatefulWidget {
  const MembershipTap({super.key});

  @override
  State<MembershipTap> createState() => _MembershipTapState();
}

class _MembershipTapState extends State<MembershipTap> {
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
          ],
        ),
      ),
    );
  }
}
