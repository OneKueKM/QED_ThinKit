import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:page_transition/page_transition.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Schedule/TeamScheduleDetailTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/TeamTap.dart';

import 'package:qed_app_thinkit/Main/2_Calendar/2_Calendar_Widget/MainCalendar.dart';
import 'package:qed_app_thinkit/Main/2_Calendar/2_Calendar_Widget/CalendarScheduleCard.dart';
import 'package:qed_app_thinkit/BasicWidgets/ScheduleDateTimeToStr.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    final currentUserRef =
        FirebaseFirestore.instance.collection('Users').doc(me!.uid);

    DateTime startOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    DateTime endOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
                eventLoader: (day) {
                  DateTime scheduleday =
                      DateTime(2023, 5, 25); // 임의 설정. 일정 표시 기능을 보여주기 위함

                  if (day.year == scheduleday.year &&
                      day.month == scheduleday.month &&
                      day.day == scheduleday.day) return ['scheduleday'];

                  return [];
                },
              ),
              FutureBuilder(
                  future: currentUserRef
                      .collection('MySchedule')
                      .orderBy('startTime', descending: false)
                      .get(),
                  builder: (context, snapshot) {
                    final myScheduleList = snapshot.data?.docs;
                    if (myScheduleList != null) {
                      if (myScheduleList.isNotEmpty) {
                        /*selected date에 해당하는 스케쥴 수를 세는 반복문. 없으면 문구 띄움*/
                        int scheduleCount = 0;
                        for (int i = 0; i < myScheduleList.length; i++) {
                          if (myScheduleList[i]['startTime'].toDate().compareTo(startOfDay) >= 0 &&
                              myScheduleList[i]['endTime'].toDate().compareTo(endOfDay) <= 0) {
                            scheduleCount++;
                          } else if (myScheduleList[i]['startTime'].toDate().compareTo(startOfDay) < 0 &&
                              myScheduleList[i]['endTime'].toDate().compareTo(endOfDay) > 0) {
                            scheduleCount++;
                          } else if (0 <= myScheduleList[i]['startTime'].toDate().compareTo(startOfDay) &&
                              myScheduleList[i]['startTime'].toDate().compareTo(endOfDay) <= 0 &&
                              myScheduleList[i]['endTime'].toDate().compareTo(endOfDay) > 0) {
                            scheduleCount++;
                          } else if (0 <= myScheduleList[i]['endTime'].toDate().compareTo(startOfDay) &&
                              myScheduleList[i]['endTime'].toDate().compareTo(endOfDay) <= 0 &&
                              myScheduleList[i]['startTime'].toDate().compareTo(startOfDay) < 0) {
                            scheduleCount++;
                          }
                        }
                        if (scheduleCount == 0) {
                          return const Center(
                            child: Text('함께할 일정을 추가해보세요',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )),
                          );
                        } else {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myScheduleList.length,
                            itemBuilder: (context, index) {
                              /*One Day Schedule*/
                              if (myScheduleList[index]['startTime'].toDate().compareTo(startOfDay) >= 0 &&
                                  myScheduleList[index]['endTime'].toDate().compareTo(endOfDay) <= 0) {
                                return CalendarScheduleCard(
                                  title: myScheduleList[index]['title'],
                                  subtitle: myScheduleList[index]['location'] == ''
                                          ? myScheduleList[index]['content']
                                          : myScheduleList[index]['location'],
                                  //장소가 있으면 장소, 없으면 content를 보여줌
                                  startTime: ScheduleDateTimeToStr(myScheduleList[index]['startTime'].toDate(), true),
                                  endTime: ScheduleDateTimeToStr(myScheduleList[index]['endTime'].toDate(), true),
                                  ontap: () {
                                    HapticFeedback.lightImpact();
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamTap(
                                              currentUserRef: currentUserRef,
                                              teamRef: myScheduleList[index]['teamRef'],
                                              selectedDate: selectedDate,),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                    Future.delayed(const Duration(milliseconds: 800), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamScheduleDetailTap(
                                              isScheduler: myScheduleList[index]['schedulerRef'] == currentUserRef
                                                  ? true
                                                  : false,
                                              scheduleRef: myScheduleList[index]['scheduleRef'],
                                              schedulerRef: myScheduleList[index]['schedulerRef'],
                                              currentUserRef: currentUserRef,
                                            ),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                  },
                                );
                              }
                              /*All Day Schedule*/
                              else if (myScheduleList[index]['startTime'].toDate().compareTo(startOfDay) < 0 &&
                                  myScheduleList[index]['endTime'].toDate().compareTo(endOfDay) > 0) {
                                return CalendarScheduleCard(
                                  title: myScheduleList[index]['title'],
                                  subtitle: myScheduleList[index]['location'] == ''
                                          ? myScheduleList[index]['content']
                                          : myScheduleList[index]['location'],
                                  //장소가 있으면 장소, 없으면 content를 보여줌
                                  startTime: '하루 종일',
                                  ontap: () {
                                    HapticFeedback.lightImpact();
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamTap(
                                              currentUserRef: currentUserRef,
                                              teamRef: myScheduleList[index]['teamRef'],
                                              selectedDate: selectedDate,),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                    Future.delayed(const Duration(milliseconds: 800), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamScheduleDetailTap(
                                              isScheduler: myScheduleList[index]['schedulerRef'] == currentUserRef
                                                  ? true
                                                  : false,
                                              scheduleRef: myScheduleList[index]['scheduleRef'],
                                              schedulerRef: myScheduleList[index]['schedulerRef'],
                                              currentUserRef: currentUserRef,
                                            ),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                  },
                                );
                              }
                              /*Start Schedule*/
                              else if (0 <= myScheduleList[index]['startTime'].toDate().compareTo(startOfDay) &&
                                  myScheduleList[index]['startTime'].toDate().compareTo(endOfDay) <= 0 &&
                                  myScheduleList[index]['endTime'].toDate().compareTo(endOfDay) > 0) {
                                return CalendarScheduleCard(
                                  title: myScheduleList[index]['title'],
                                  subtitle: myScheduleList[index]['location'] == ''
                                          ? myScheduleList[index]['content']
                                          : myScheduleList[index]['location'],
                                  //장소가 있으면 장소, 없으면 content를 보여줌
                                  startTime: ScheduleDateTimeToStr(myScheduleList[index]['startTime'].toDate(), true),
                                  ontap: () {
                                    HapticFeedback.lightImpact();
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamTap(
                                              currentUserRef: currentUserRef,
                                              teamRef: myScheduleList[index]['teamRef'],
                                              selectedDate: selectedDate,),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                    Future.delayed(const Duration(milliseconds: 800), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamScheduleDetailTap(
                                              isScheduler: myScheduleList[index]['schedulerRef'] == currentUserRef
                                                  ? true
                                                  : false,
                                              scheduleRef: myScheduleList[index]['scheduleRef'],
                                              schedulerRef: myScheduleList[index]['schedulerRef'],
                                              currentUserRef: currentUserRef,
                                            ),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                  },
                                );
                              }
                              /*End Schedule*/
                              else if (0 <= myScheduleList[index]['endTime'].toDate().compareTo(startOfDay) &&
                                  myScheduleList[index]['endTime'].toDate().compareTo(endOfDay) <= 0 &&
                                  myScheduleList[index]['startTime'].toDate().compareTo(startOfDay) < 0) {
                                return CalendarScheduleCard(
                                  title: myScheduleList[index]['title'],
                                  subtitle: myScheduleList[index]['location'] == ''
                                          ? myScheduleList[index]['content']
                                          : myScheduleList[index]['location'],
                                  //장소가 있으면 장소, 없으면 content를 보여줌
                                  endTime: ScheduleDateTimeToStr(myScheduleList[index]['endTime'].toDate(), true),
                                  ontap: () {
                                    HapticFeedback.lightImpact();
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamTap(
                                              currentUserRef: currentUserRef,
                                              teamRef: myScheduleList[index]['teamRef'],
                                              selectedDate: selectedDate,),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                    Future.delayed(const Duration(milliseconds: 800), () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: TeamScheduleDetailTap(
                                              isScheduler: myScheduleList[index]['schedulerRef'] == currentUserRef
                                                  ? true
                                                  : false,
                                              scheduleRef: myScheduleList[index]['scheduleRef'],
                                              schedulerRef: myScheduleList[index]['schedulerRef'],
                                              currentUserRef: currentUserRef,
                                            ),
                                          )).then((value) {
                                        setState(() {});
                                      });
                                    });
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      } else {
                        return const Center(
                          child: Text('일정을 추가해보세요',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 15.0,
                              )),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
    }); // 날짜 선택시 실행되는 함수. selectedDate 변수를 선택한 날짜로 바꿈
  }
}
