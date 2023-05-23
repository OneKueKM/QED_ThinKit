import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qed_app_thinkit/BasicWidgets/DateTimeToStr.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Announcement/TeamAnnouncementEditTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Announcement/TeamAnnouncementDetailCommentBox.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Announcement/TeamAnnouncementDetailCommentCard.dart';

import 'package:page_transition/page_transition.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementDetailTap extends StatefulWidget {
  final bool announcer;
  final DocumentReference announcementRef;
  final DocumentReference announcerRef;
  final DocumentReference currentUserRef; //댓글 남긴 사람 ref 저장

  const TeamAnnouncementDetailTap(
      {required this.announcer,
      required this.announcementRef,
      required this.announcerRef,
      required this.currentUserRef,
      Key? key})
      : super(key: key);

  @override
  State<TeamAnnouncementDetailTap> createState() =>
      _TeamAnnouncementDetailTapState();
}

enum MenuType {
  first,
  second,
}

class _TeamAnnouncementDetailTapState extends State<TeamAnnouncementDetailTap> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.announcementRef.get(),
        builder: (context, snapshot) {
          final announceData = snapshot.data;
          if (announceData != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  '상세보기',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                elevation: 0,
                /*뒤로 가기 버튼*/
                leading: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                actions: [
                  widget.announcer
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
                                    child: TeamAnnouncementEditTap(
                                        content:
                                            announceData['announceContent'],
                                        announcementRef:
                                            widget.announcementRef),
                                  )).then((value) {
                                setState(() {});
                              });
                            } else {
                              _commnetDelFunc();
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
                      : Container()
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*공지 쓴 사람 프로필 및 날짜 표시*/
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder(
                            future: widget.announcerRef.get(),
                            builder: (context, snapshot) {
                              final announcerData = snapshot.data;

                              if (announcerData != null) {
                                return Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                            color: Color(0xfff1efef)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                announcerData['userProfile'])),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(announcerData['userName'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 17.0,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Text(
                                          DateTimeToStr(
                                              announceData['announceDate']
                                                  .toDate()),
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      /*공지 내용*/
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          bottom: 10,
                        ),
                        child: Text(
                          announceData['announceContent'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      /*광고 영역?*/
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
                            future: widget.announcementRef
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
                                          if (commentsList[index]
                                                  ['commenterRef'] ==
                                              widget.currentUserRef) {
                                            showDialog(
                                                context: context,
                                                //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                    actions: [
                                                      Container(
                                                        color: Colors.white,
                                                        width: double.infinity,
                                                        child: TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0)),
                                                                      content:
                                                                          const Text(
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
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: const [
                                                                Text(
                                                                  '  삭제',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
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
              bottomNavigationBar: TeamAnnouncementDetailCommentBox(
                announcementRef: widget.announcementRef,
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

  void _commnetDelFunc() {
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
              "공지 삭제",
              textAlign: TextAlign.center,
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "정말로 공지를 삭제하시겠습니까?",
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
                            widget.announcementRef.delete(),
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
