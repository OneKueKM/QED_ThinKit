import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'package:qed_app_thinkit/BasicWidgets/ScheduleDateTimeToStr.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Schedule/TeamScheduleEditTap.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Announcement/TeamAnnouncementDetailCommentCard.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Schedule/TeamScheduleDetailCommentBox.dart';

class TeamScheduleDetailTap extends StatefulWidget {
  final bool isScheduler;
  final DocumentReference scheduleRef;
  final DocumentReference schedulerRef;
  final DocumentReference currentUserRef; //댓글 남긴 사람 ref 저장하기 위해 필요

  const TeamScheduleDetailTap(
      {required this.isScheduler,
      required this.scheduleRef,
      required this.schedulerRef,
      required this.currentUserRef,
      Key? key})
      : super(key: key);

  @override
  State<TeamScheduleDetailTap> createState() => _TeamScheduleDetailTapState();
}

enum MenuType {
  first,
  second,
}

class _TeamScheduleDetailTapState extends State<TeamScheduleDetailTap> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.scheduleRef.get(),
        builder: (context, snapshot) {
          final schedulesData = snapshot.data;
          if (schedulesData != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  '상세보기',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => {
                    HapticFeedback.lightImpact(),
                    Navigator.pop(context),
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                /*스케쥴 수정 및 삭제 버튼*/
                actions: [
                  widget.isScheduler
                      ? PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          position: PopupMenuPosition.under,
                          onSelected: (MenuType result) {
                            if (result == MenuType.first) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: TeamScheduleEditTap(
                                      scheduleTitle: schedulesData['title'],
                                      scheduleLoaction:
                                          schedulesData['location'],
                                      scheduleContent: schedulesData['content'],
                                      startTime:
                                          schedulesData['startTime'].toDate(),
                                      endTime:
                                          schedulesData['endTime'].toDate(),
                                      scheduleRef: widget.scheduleRef,
                                    ),
                                  )).then((value) {
                                setState(() {});
                              });
                            } else {
                              _showDeleteDialog();
                            }
                          },
                          itemBuilder: (BuildContext buildContext) {
                            return [
                              for (final value in MenuType.values)
                                PopupMenuItem(
                                  value: value,
                                  child: value == MenuType.first
                                      ? const Text('수정')
                                      : const Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                )
                            ];
                          },
                        )
                      : Container(),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*스케쥴 제목*/
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          schedulesData['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      /*스케쥴 시간*/
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ScheduleDateTimeToStr(
                                  schedulesData['startTime'].toDate(), false),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '> ${ScheduleDateTimeToStr(schedulesData['endTime'].toDate(), false)}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*스케쥴 장소*/
                      schedulesData['location'] == '' //장소 없으면 위젯 없앰
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '장소',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                    schedulesData['location'],
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                      /*스케쥴 내용*/
                      schedulesData['content'] == ''
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '내용',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                    schedulesData['content'],
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                      /*작성자 프로필 표시*/
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                            future: widget.schedulerRef.get(),
                            builder: (context, snapshot) {
                              final schedulerData = snapshot.data;

                              if (schedulerData != null) {
                                return Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                            color: Color(0xfff1efef)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                schedulerData['userProfile'])),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(schedulerData['userName'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 15.0,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        const Text(
                                          '이(가) 작성',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      /*광고 영역*/
                      Container(
                        color: Colors.grey[300],
                        height: 70,
                        width: double.infinity,
                        child: const Text('여기 광고 넣음 좋을듯'),
                      ),
                      /*댓글 리스트 영역*/
                      Container(
                        constraints: const BoxConstraints(),
                        //최대 높이를 위젯에 맞게 설정하는 코드
                        child: FutureBuilder(
                            future: widget.scheduleRef
                                .collection('Comments')
                                .orderBy('commentDate', descending: false)
                                .get(),
                            //최근 댓글이 젤 밑에
                            builder: (context, snapshot) {
                              final commentsList = snapshot.data?.docs;

                              if (commentsList != null) {
                                return ListView.builder(
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: commentsList.length,
                                    itemBuilder: (context, index) {
                                      return TeamAnnouncementDetailCommentCard(
                                        commentContent: commentsList[index]
                                        ['commentContent'],
                                        commentDate: commentsList[index]
                                        ['commentDate']
                                            .toDate(),
                                        commenterRef: commentsList[index]
                                        ['commenterRef'],
                                        commentDelFunc: () {
                                          /*댓글 삭제 함수*/
                                          if (commentsList[index]['commenterRef'] == widget.currentUserRef) {
                                            showDialog(
                                                context: context,
                                                //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    actions: [
                                                      Container(
                                                        color: Colors.white,
                                                        width: double.infinity,
                                                        child: TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              showDialog(
                                                                  context: context,
                                                                  //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                                                  barrierDismissible: true,
                                                                  builder: (context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(10.0)),
                                                                      content: const Text(
                                                                          '댓글을 삭제하시겠습니까?'),
                                                                      actions: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text(
                                                                                  '아니오',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                )),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                  commentsList[index].reference.delete();
                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text(
                                                                                  '예',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: const [
                                                                Text('  삭제', style: TextStyle(color: Colors.black),),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }
                                        },
                                      );
                                    });
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: TeamScheduleDetailCommentBox(
                scheduleRef: widget.scheduleRef,
                currentUserRef: widget.currentUserRef,
                refresh: () {
                  setState(() {});
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }

  void _showDeleteDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Text(
              "일정 삭제",
              textAlign: TextAlign.center,
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "정말로 일정을 삭제하시겠습니까?",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () => {
                            Navigator.pop(context),
                          },
                      child: const Text(
                        '취소',
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton(
                      onPressed: () => {
                            HapticFeedback.lightImpact(),
                            widget.scheduleRef.delete(),
                            Navigator.pop(context),
                            Navigator.pop(context),
                            // 스케쥴 삭제 후 ㅁTeamTap으로 이동 >> 이 화면 자체가 데이터를 스트림으로 불러와서 오류 생김
                          },
                      child: const Text(
                        '삭제',
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ),
            ],
          );
        });
  }
}
