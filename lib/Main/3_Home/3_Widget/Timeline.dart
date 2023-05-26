import 'package:flutter/material.dart';

import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:tabler_icons/tabler_icons.dart';

class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  double currentTimePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    updateCurrentTimePercentage();
  }

  void updateCurrentTimePercentage() {
    DateTime now = DateTime.now();
    int totalMinutes = 1440;
    int currentMinutes = now.hour * 60 + now.minute;
    double percentage = (currentMinutes / totalMinutes);
    setState(() {
      currentTimePercentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '타임라인',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // branch commit test
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 15,
                  width: 15,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/gifs/redLiveDot.gif')),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(width: 40),
                Container(
                  height: 15,
                  width: 15,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/gifs/redLiveDot.gif')),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(width: 20)
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CupertinoProgressBar(
                valueColor: const Color.fromARGB(255, 69, 182, 73),
                value: currentTimePercentage,
              ),
            ),
            const SizedBox(height: 15),
            Container(
                width: double.infinity,
                height: 146,
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
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text('VC 보고서 준비',
                                  style: TextStyle(
                                      fontFamily: 'SFProText',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Icon(
                                TablerIcons.brand_telegram,
                                size: 22,
                              )
                            ],
                          )),
                      const SizedBox(height: 1),
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
                          children: const [
                            Text('오후 6시  /  사무실',
                                style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      SizedBox(
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('경영 전략 평가 중심으로 편성',
                                style: TextStyle(
                                    fontFamily: 'SFProText',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))
                          ],
                        ),
                      ),
                      const SizedBox(height: 9),
                      SizedBox(
                        height: 39,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 41,
                              child: Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://image.zdnet.co.kr/2023/03/09/356dff25278b5a49593defb99b15eade.jpg'))),
                                  ),
                                  const SizedBox(width: 3),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://img.biz.sbs.co.kr/upload/2023/03/25/d1d1679728257145-850.jpg'))),
                                  ),
                                  const SizedBox(width: 3),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://www.womennews.co.kr/news/photo/202201/219795_358815_013.jpg'))),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    TablerIcons.dots,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: null,
                                    child: Container(
                                      width: 60,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 69, 182, 73),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text('완 료',
                                              style: TextStyle(
                                                  fontFamily: 'SFProText',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
