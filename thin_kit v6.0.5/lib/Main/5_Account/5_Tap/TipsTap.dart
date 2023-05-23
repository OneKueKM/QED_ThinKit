import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class TipsTap extends StatefulWidget {
  const TipsTap({super.key});

  @override
  State<TipsTap> createState() => _TipsTapState();
}

class _TipsTapState extends State<TipsTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(TablerIcons.chevron_left),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Tips',
            style: TextStyle(
                fontFamily: 'SFProText',
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17),
          ),
        ),
        body: SafeArea(
          // 앱의 실제 화면 크기를 계산 => 이를 영역으로 삼아 내용 표시 => "잘리거나 가려지는 부분 x!"
          child: ScrollConfiguration(
            // 스크롤 효과 제거
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                children: [
                  Container(
                    color: Colors.white,
                    height: 70,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Processing...',
                                style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                ]),
          ),
        ));
  }
}
