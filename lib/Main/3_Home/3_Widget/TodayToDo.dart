import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class todayToDo extends StatefulWidget {
  todayToDo({super.key});

  @override
  State<todayToDo> createState() => _todayToDoState();
}

class _todayToDoState extends State<todayToDo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  '오늘 할 일',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 25,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                          height: 17,
                          child:
                              Icon(TablerIcons.square_rounded_check, size: 17)),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 20,
                        child: Text(
                          '유튜브 프리미엄 결제',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 20,
                          child: Text(
                            '재정캘린더',
                            style: TextStyle(
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color.fromARGB(255, 122, 122, 122)),
                          ),
                        ),
                        SizedBox(
                            height: 17,
                            child: Icon(
                              TablerIcons.chevron_right,
                              size: 15,
                              color: Color.fromARGB(255, 122, 122, 122),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 25,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                          height: 17,
                          child: Icon(TablerIcons.square_rounded, size: 17)),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 20,
                        child: Text(
                          '저녁에 안성탕면 먹기',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 20,
                          child: Text(
                            '투두리스트',
                            style: TextStyle(
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color.fromARGB(255, 122, 122, 122)),
                          ),
                        ),
                        SizedBox(
                            height: 17,
                            child: Icon(
                              TablerIcons.chevron_right,
                              size: 15,
                              color: Color.fromARGB(255, 122, 122, 122),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 25,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                          height: 17,
                          child: Icon(TablerIcons.square_rounded, size: 17)),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 20,
                        child: Text(
                          '센트럴파크 1시간 걷기',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 20,
                          child: Text(
                            '투두리스트',
                            style: TextStyle(
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color.fromARGB(255, 122, 122, 122)),
                          ),
                        ),
                        SizedBox(
                            height: 17,
                            child: Icon(
                              TablerIcons.chevron_right,
                              size: 15,
                              color: Color.fromARGB(255, 122, 122, 122),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 25,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(
                          height: 17,
                          child: Icon(TablerIcons.square_rounded, size: 17)),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 20,
                        child: Text(
                          '자기 전 피부 관리',
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 20,
                          child: Text(
                            '루틴',
                            style: TextStyle(
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color.fromARGB(255, 122, 122, 122)),
                          ),
                        ),
                        SizedBox(
                            height: 17,
                            child: Icon(
                              TablerIcons.chevron_right,
                              size: 15,
                              color: Color.fromARGB(255, 122, 122, 122),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
