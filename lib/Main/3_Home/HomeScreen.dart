import 'package:flutter/material.dart';

import 'package:qed_app_thinkit/BasicWidgets/obtaindate.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/TodayToDo.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/WeatherWidget.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Tap/NewNotiTap.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/Notice.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/Timeline.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/HsKakaoAds.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/SearchRank.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Widget/SpendHistory.dart';

import 'package:tabler_icons/tabler_icons.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> requestNew() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await const HomeScreen();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* 상단 앱바 구현부 : 이모티콘 2개, 현재 날짜 */
      appBar: AppBar(
        leadingWidth: 55,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [SizedBox(width: 10), WeatherWidget()],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(TablerIcons.bell),
            color: Colors.red,
            iconSize: 25,
            onPressed: () => {
              HapticFeedback.lightImpact(),
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const NewNotiTap()))
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: requestNew,
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            DataAppBar().getKoreanWeek(
                                DataAppBar().getweekDay()), // 현재 날짜의 "요일" 출력부
                            style: TextStyle(
                              fontFamily: 'SFProText',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: (DataAppBar().getweekDay() == 7)
                                  ? Colors.red
                                  : (DataAppBar().getweekDay() == 6)
                                      ? Colors.blue
                                      : Colors.black,
                            )),
                        const SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(DataAppBar().getSystemTime(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12)),
                            const SizedBox(height: 2)
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Notice(),
                  const SizedBox(height: 10),
                  const Timeline(),
                  const SizedBox(height: 15),
                  todayToDo(),
                  const SizedBox(height: 15),
                  const HsKakaoAds(),
                  const SizedBox(height: 10),
                  const SearchRank(),
                  const SizedBox(height: 10),
                  spendHistory(),
                  const SizedBox(height: 50),
                ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 기능 추가 예정
        },
        splashColor: Colors.transparent,
        highlightElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(TablerIcons.rocket,
            size: 40, color: Color.fromARGB(255, 0, 110, 200)),
      ),
    );
  }
}
