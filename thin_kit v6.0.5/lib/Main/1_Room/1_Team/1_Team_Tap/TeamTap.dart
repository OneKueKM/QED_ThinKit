import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qed_app_thinkit/BasicWidgets/ScheduleDateTimeToStr.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Announcement/TeamAnnouncementTap.dart';

import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Schedule/TeamScheduleAddTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Drawer/TeamDrawer.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Schedule/TeamScheduleDetailTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/TeamCalendar.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Schedule/TeamScheduleCard.dart';

import 'package:tabler_icons/tabler_icons.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamTap extends StatefulWidget {
  final DocumentReference currentUserRef;
  final DocumentReference teamRef;
  final DateTime selectedDate;

  const TeamTap(
      {required this.currentUserRef,
      required this.teamRef,
      required this.selectedDate,
      Key? key})
      : super(key: key);

  @override
  State<TeamTap> createState() => _TeamTapState();
}

class _TeamTapState extends State<TeamTap> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    /*My team Ref를 얻음*/
    DocumentReference myTeamRef = widget.teamRef;
    widget.currentUserRef
        .collection('MyTeams')
        .where('teamRef', isEqualTo: widget.teamRef)
        .get()
        .then((QuerySnapshot doc) {
      myTeamRef = doc.docs[0].reference;
    });
    //bool admin = widget.adminsList.contains(widget.currentUserRef) ? true : false;
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
    return FutureBuilder(
        future: widget.teamRef.get(),
        builder: (context, snapshot) {
          final teamData = snapshot.data;
          if (teamData != null) {
            /*Admin 여부 파악*/
            bool isAdmin =
                teamData['teamAdmins'].contains(widget.currentUserRef)
                    ? true
                    : false;

            return Scaffold(
              endDrawer: Drawer(
                width: MediaQuery.of(context).size.width * 4 / 5,
                child: TeamDrawer(
                  currentUserRef: widget.currentUserRef,
                  myTeamRef: myTeamRef, //모르겠다 씨발
                  teamRef: widget.teamRef,
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  teamData['teamName'],
                  style: const TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                elevation: 0,
                /*뒤로 가기 버튼*/
                leading: IconButton(
                  onPressed: () =>
                      {HapticFeedback.lightImpact(), Navigator.pop(context)},
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                /*팀 서랍 버튼*/
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        TablerIcons.bell,
                        color: Colors.grey,
                        size: 30,
                      )),
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /*팀 캘린더*/
                      TeamCalendar(
                          onDaySelected: onDaySelected,
                          selectedDate: selectedDate),
                      /*버튼 영역*/
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  if (isAdmin) // 어드민이 아닌 유저는 일정 추가 불가
                                  {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child: TeamScheduleAddTap(
                                            selectedDate: selectedDate,
                                            teamRef: widget.teamRef,
                                            currentUserRef:
                                                widget.currentUserRef,
                                            teamMembers:
                                                teamData['teamMembers'],
                                          ),
                                        )).then((value) {
                                      setState(() {});
                                    });
                                  } else {}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isAdmin ? Colors.grey[300] : Colors.white,
                                  side: BorderSide(width: 1.0),
                                  elevation: 0,
                                ),
                                child: Text(
                                  '새로운 일정',
                                  style: TextStyle(
                                    color: isAdmin ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              onPressed: () => setState(() {
                                selectedDate = DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                );
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                side: BorderSide(width: 1.0),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Today',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*팀 공지*/
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: TeamAnnouncementTap(
                                    isAdmin: isAdmin,
                                    teamRef: widget.teamRef,
                                    currentUserRef: widget.currentUserRef,
                                  ))).then((value) {
                            setState(() {});
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.announcement_outlined,
                                color: Colors.black),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '공지',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      /*스케쥴 표시 영역*/
                      FutureBuilder(
                        future: widget.teamRef
                            .collection('Schedules')
                            .orderBy('startTime', descending: false)
                            .get(),
                        builder: (context, snapshot) {
                          final scheduleList = snapshot.data?.docs;

                          if (scheduleList != null) {
                            if (scheduleList.isNotEmpty) {
                              /*selected date에 해당하는 스케쥴 수를 세는 반복문. 없으면 문구 띄움*/
                              int scheduleCount = 0;
                              for (int i = 0; i < scheduleList.length; i++) {
                                if (scheduleList[i]['startTime'].toDate().compareTo(startOfDay) >= 0 &&
                                    scheduleList[i]['endTime']
                                            .toDate()
                                            .compareTo(endOfDay) <=
                                        0) {
                                  scheduleCount++;
                                } else if (scheduleList[i]['startTime']
                                            .toDate()
                                            .compareTo(startOfDay) <
                                        0 &&
                                    scheduleList[i]['endTime'].toDate().compareTo(endOfDay) >
                                        0) {
                                  scheduleCount++;
                                } else if (0 <=
                                        scheduleList[i]['startTime']
                                            .toDate()
                                            .compareTo(startOfDay) &&
                                    scheduleList[i]['startTime']
                                            .toDate()
                                            .compareTo(endOfDay) <=
                                        0 &&
                                    scheduleList[i]['endTime'].toDate().compareTo(endOfDay) >
                                        0) {
                                  scheduleCount++;
                                } else if (0 <= scheduleList[i]['endTime'].toDate().compareTo(startOfDay) &&
                                    scheduleList[i]['endTime'].toDate().compareTo(endOfDay) <= 0 &&
                                    scheduleList[i]['startTime'].toDate().compareTo(startOfDay) < 0) {
                                  scheduleCount++;
                                }
                              }
                              if (scheduleCount == 0) {
                                return const Center(
                                  child: Text('팀과 함께할 일정을 추가해보세요',
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
                                  itemCount: scheduleList.length,
                                  itemBuilder: (context, index) {
                                    /*One Day Schedule*/
                                    if (scheduleList[index]['startTime']
                                                .toDate()
                                                .compareTo(startOfDay) >=
                                            0 &&
                                        scheduleList[index]['endTime']
                                                .toDate()
                                                .compareTo(endOfDay) <=
                                            0) {
                                      return TeamScheduleCard(
                                        title: scheduleList[index]['title'],
                                        subtitle: scheduleList[index]
                                                    ['location'] ==
                                                ''
                                            ? scheduleList[index]['content']
                                            : scheduleList[index]['location'],
                                        //장소가 있으면 장소, 없으면 content를 보여줌
                                        startTime: ScheduleDateTimeToStr(
                                            scheduleList[index]['startTime']
                                                .toDate(),
                                            true),
                                        endTime: ScheduleDateTimeToStr(
                                            scheduleList[index]['endTime']
                                                .toDate(),
                                            true),
                                        ontap: () {
                                          HapticFeedback.lightImpact();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: TeamScheduleDetailTap(
                                                  isScheduler: scheduleList[
                                                                  index][
                                                              'schedulerRef'] ==
                                                          widget.currentUserRef
                                                      ? true
                                                      : false, //스케쥴 작성 여부 전달
                                                  scheduleRef:
                                                      scheduleList[index]
                                                          .reference,
                                                  schedulerRef:
                                                      scheduleList[index]
                                                          ['schedulerRef'],
                                                  currentUserRef:
                                                      widget.currentUserRef,
                                                ),
                                              )).then((value) {
                                            setState(() {});
                                          });
                                        },
                                      );
                                    }
                                    /*All Day Schedule*/
                                    else if (scheduleList[index]['startTime']
                                                .toDate()
                                                .compareTo(startOfDay) <
                                            0 &&
                                        scheduleList[index]['endTime']
                                                .toDate()
                                                .compareTo(endOfDay) >
                                            0) {
                                      return TeamScheduleCard(
                                        title: scheduleList[index]['title'],
                                        subtitle: scheduleList[index]
                                                    ['location'] ==
                                                ''
                                            ? scheduleList[index]['content']
                                            : scheduleList[index]['location'],
                                        //장소가 있으면 장소, 없으면 content를 보여줌
                                        startTime: '하루 종일',
                                        ontap: () {
                                          HapticFeedback.lightImpact();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: TeamScheduleDetailTap(
                                                  isScheduler: scheduleList[
                                                                  index][
                                                              'schedulerRef'] ==
                                                          widget.currentUserRef
                                                      ? true
                                                      : false, //어드민 여부 전달
                                                  scheduleRef:
                                                      scheduleList[index]
                                                          .reference,
                                                  schedulerRef:
                                                      scheduleList[index]
                                                          ['schedulerRef'],
                                                  currentUserRef:
                                                      widget.currentUserRef,
                                                ),
                                              )).then((value) {
                                            setState(() {});
                                          });
                                        },
                                      );
                                    }
                                    /*Start Schedule*/
                                    else if (0 <=
                                            scheduleList[index]['startTime']
                                                .toDate()
                                                .compareTo(startOfDay) &&
                                        scheduleList[index]['startTime']
                                                .toDate()
                                                .compareTo(endOfDay) <=
                                            0 &&
                                        scheduleList[index]['endTime']
                                                .toDate()
                                                .compareTo(endOfDay) >
                                            0) {
                                      return TeamScheduleCard(
                                        title: scheduleList[index]['title'],
                                        subtitle: scheduleList[index]
                                                    ['location'] ==
                                                ''
                                            ? scheduleList[index]['content']
                                            : scheduleList[index]['location'],
                                        //장소가 있으면 장소, 없으면 content를 보여줌
                                        startTime: ScheduleDateTimeToStr(
                                            scheduleList[index]['startTime']
                                                .toDate(),
                                            true),
                                        ontap: () {
                                          HapticFeedback.lightImpact();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: TeamScheduleDetailTap(
                                                  isScheduler: scheduleList[
                                                                  index][
                                                              'schedulerRef'] ==
                                                          widget.currentUserRef
                                                      ? true
                                                      : false, //어드민 여부 전달
                                                  scheduleRef:
                                                      scheduleList[index]
                                                          .reference,
                                                  schedulerRef:
                                                      scheduleList[index]
                                                          ['schedulerRef'],
                                                  currentUserRef:
                                                      widget.currentUserRef,
                                                ),
                                              )).then((value) {
                                            setState(() {});
                                          });
                                        },
                                      );
                                    }
                                    /*End Schedule*/
                                    else if (0 <=
                                            scheduleList[index]['endTime']
                                                .toDate()
                                                .compareTo(startOfDay) &&
                                        scheduleList[index]['endTime']
                                                .toDate()
                                                .compareTo(endOfDay) <=
                                            0 &&
                                        scheduleList[index]['startTime']
                                                .toDate()
                                                .compareTo(startOfDay) <
                                            0) {
                                      return TeamScheduleCard(
                                        title: scheduleList[index]['title'],
                                        subtitle: scheduleList[index]
                                                    ['location'] ==
                                                ''
                                            ? scheduleList[index]['content']
                                            : scheduleList[index]['location'],
                                        //장소가 있으면 장소, 없으면 content를 보여줌
                                        endTime: ScheduleDateTimeToStr(
                                            scheduleList[index]['endTime']
                                                .toDate(),
                                            true),
                                        ontap: () {
                                          HapticFeedback.lightImpact();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: TeamScheduleDetailTap(
                                                  isScheduler: scheduleList[
                                                                  index][
                                                              'schedulerRef'] ==
                                                          widget.currentUserRef
                                                      ? true
                                                      : false, //어드민 여부 전달
                                                  scheduleRef:
                                                      scheduleList[index]
                                                          .reference,
                                                  schedulerRef:
                                                      scheduleList[index]
                                                          ['schedulerRef'],
                                                  currentUserRef:
                                                      widget.currentUserRef,
                                                ),
                                              )).then((value) {
                                            setState(() {});
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
                                child: Text('팀과 함께할 일정을 추가해보세요',
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
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
