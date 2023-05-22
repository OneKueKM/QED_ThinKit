import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'package:qed_app_thinkit/main.dart';

import 'package:qed_app_thinkit/Main/5_Account/5_Tap/SettingsTap.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:page_transition/page_transition.dart';

class Explains extends StatelessWidget {
  const Explains({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      TablerIcons.book,
                      size: 25,
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                '약관 및 정책',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Color.fromARGB(255, 77, 77, 77),
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 10,
            width: 500,
            child: const Divider(
                color: Color.fromARGB(255, 222, 222, 222), thickness: 1)),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SettingsTap()))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    '이용약관',
                    style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 15, 10, 0),
            child: GestureDetector(
              onTap: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    '개인정보 처리방침',
                    style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: 25,
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      TablerIcons.phone,
                      size: 25,
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                '문의',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Color.fromARGB(255, 77, 77, 77),
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 10,
            width: 500,
            child: const Divider(
                color: Color.fromARGB(255, 222, 222, 222), thickness: 1)),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: GestureDetector(
              onTap: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    '제휴 문의하기',
                    style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 15, 10, 0),
            child: GestureDetector(
              onTap: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    '피드백 보내기',
                    style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 15, 10, 0),
            child: GestureDetector(
              onTap: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    '고객센터',
                    style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: 25,
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      TablerIcons.checks,
                      size: 25,
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                '버전 정보',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Color.fromARGB(255, 77, 77, 77),
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 10,
            width: 500,
            child: const Divider(
                color: Color.fromARGB(255, 222, 222, 222), thickness: 1)),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: GestureDetector(
              onTap: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    version,
                    style: const TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
        GestureDetector(
          onTap: () => FirebaseAuth.instance.signOut(),
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '로그아웃',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'SFProDisplay',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
