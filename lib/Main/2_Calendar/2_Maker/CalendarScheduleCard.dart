import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class CalendarScheduleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String startTime;
  final String endTime;
  final void Function() ontap;

  const CalendarScheduleCard(
      {required this.title,
      required this.subtitle,
      this.startTime = '',
      this.endTime = '',
      required this.ontap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: 135,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VerticalDivider(
            color: Colors.red, //중요도에 따라 색깔 설정 가능하도록 추가 예정
            width: 15,
            thickness: 3,
            indent: 25,
            endIndent: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
                height: 125,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                          spreadRadius: 3,
                          color: const Color.fromARGB(222, 166, 166, 166)
                              .withOpacity(0.3))
                    ]),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 22,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text('버크셔 해서웨이 주주총회',
                                  style: TextStyle(
                                      fontFamily: 'SFProText',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Icon(
                                TablerIcons.brand_telegram,
                                size: 20,
                              )
                            ],
                          )),
                      const SizedBox(height: 2),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 10,
                          width: 500,
                          child: const Divider(
                              color: Color.fromARGB(255, 222, 222, 222),
                              thickness: 1)),
                      const SizedBox(height: 1),
                      SizedBox(
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              child: Icon(
                                TablerIcons.clock_hour_10,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text('$startTime  —  $endTime',
                                style: const TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 20,
                              child: Icon(
                                TablerIcons.map_pin,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text('버크셔 해서웨이 본사',
                                style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 20,
                              child: Icon(
                                TablerIcons.note,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text('주주총회 내용 녹음 꼭 하기!',
                                style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
