import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Drawer/AddAdmins.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Drawer/AddMembers.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Drawer/DrawerUsersCard.dart';

import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamDrawer extends StatefulWidget {
  final DocumentReference currentUserRef;
  final DocumentReference myTeamRef;
  final DocumentReference teamRef;

  const TeamDrawer(
      {required this.currentUserRef,
      required this.myTeamRef,
      required this.teamRef,
      Key? key})
      : super(key: key);

  @override
  State<TeamDrawer> createState() => _TeamDrawerState();
}

class _TeamDrawerState extends State<TeamDrawer> {
  @override
  Widget build(BuildContext context) {

    bool favorites = false;
    widget.myTeamRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      favorites = data['favorites'];
    });

    return FutureBuilder(
      future: widget.teamRef.get(),
      builder: (context, snapshot) {
        final teamData = snapshot.data;

        if (teamData != null) {
          bool admin = teamData['teamAdmins'].contains(widget.currentUserRef)
              ? true
              : false;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '팀 서랍',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Divider(
                          color: Color.fromARGB(255, 222, 222, 222),
                          thickness: 1),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '관리자',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        /*관리자 추가 버튼*/
                        IconButton(
                          onPressed: () {
                            if (admin) {
                              Navigator.pop(context);
                              Future.delayed(const Duration(milliseconds: 400),
                                  () {
                                Get.to(
                                  () => AddAdmins(
                                    adminsList: teamData['teamAdmins'],
                                    membersList: teamData['teamMembers'],
                                    currentUserRef: widget.currentUserRef,
                                    teamRef: widget.teamRef,
                                  ),
                                );
                              });
                              /*추가 했다는 토스트 메세지? 그런거 하나 뜨면 좋을듯*/
                            }
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Colors.grey,
                          ),
                          color: teamData['teamAdmins']
                                  .contains(widget.currentUserRef)
                              ? Colors.black
                              : Colors.grey[300],
                        ),
                      ],
                    ),
                    /*관리자 프로필 표시*/
                    Container(
                      constraints: const BoxConstraints(),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: teamData['teamAdmins'].length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(teamData['teamAdmins'][index].id)
                                    .get(),
                                builder: (context, snapshot) {
                                  final adminsData = snapshot.data;
                                  if (adminsData != null) {
                                    return DrawerUsersCard(
                                      teamRef: teamData.reference,
                                      draweUserRef: teamData['teamAdmins']
                                          [index],
                                      drawerUserName: adminsData['userName'],
                                      drawerUserProfile:
                                          adminsData['userProfile'],
                                      membersList: teamData['teamMembers'],
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Divider(
                          color: Color.fromARGB(255, 222, 222, 222),
                          thickness: 1),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '멤버',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        /*멤버 추가 버튼*/
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Future.delayed(const Duration(milliseconds: 400),
                                () {
                              Get.to(
                                () => AddMembers(
                                  membersList: teamData['teamMembers'],
                                  currentUserRef: widget.currentUserRef,
                                  teamRef: widget.teamRef,
                                ),
                              );
                            });
                            /*추가 했다는 토스트 메세지? 그런거 하나 뜨면 좋을듯*/
                          },
                          icon: Icon(Icons.add_circle_outline),
                          color: Colors.grey,
                        )
                      ],
                    ),
                    /*멤버 프로필 표시*/
                    Container(
                      constraints: const BoxConstraints(),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: teamData['teamMembers'].length,
                          itemBuilder: (context, index) {
                            /*관리자면 멤버 리스트에는 표시 안함*/
                            if (teamData['teamAdmins']
                                .contains(teamData['teamMembers'][index])) {
                              return Container();
                            } else {
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(teamData['teamMembers'][index].id)
                                      .get(),
                                  builder: (context, snapshot) {
                                    final membersData = snapshot.data;
                                    if (membersData != null) {
                                      return DrawerUsersCard(
                                        admin: admin,
                                        teamRef: teamData.reference,
                                        draweUserRef: teamData['teamMembers']
                                            [index],
                                        drawerUserName: membersData['userName'],
                                        drawerUserProfile:
                                            membersData['userProfile'],
                                        membersList: teamData['teamMembers'],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top:
                          BorderSide(color: Color.fromARGB(255, 222, 222, 222)),
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 222, 222, 222)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*즐겨찾기 버튼*/
                  IconButton(
                    onPressed: () {
                      if (favorites) {
                        widget.myTeamRef.update({'favorites': false});
                        setState(() {});
                      } else {
                        widget.myTeamRef.update({'favorites': true});
                        setState(() {});
                      }
                    },
                    icon: favorites
                        ? Icon(
                            Icons.star,
                            color: Colors.grey,
                          )
                        : Icon(
                            Icons.star_border,
                            color: Colors.grey,
                          ),
                  ),
                  /*팀 설정 버튼*/
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        color: Colors.grey,
                      )),
                  /*나가기 버튼*/
                  IconButton(
                    onPressed: () => {
                      if (admin)
                        {
                          if (teamData['teamAdmins'].length >= 1)
                            {
                              _showAdminExitDialog(
                                  teamData['teamName'],
                                  teamData['teamAdmins'],
                                  teamData['teamMembers'])
                            }
                          else
                            /*관리자가 한 명일 때 나갈 수 없다는 dialog*/
                            {
                              showDialog(
                                  context: context,
                                  //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      //Dialog Main Title
                                      title: const Text(
                                        "팀을 떠날 수 없습니다",
                                        textAlign: TextAlign.center,
                                      ),
                                      //
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const <Widget>[
                                          Text(
                                            "팀의 관리자가 한 명 이상이어야 합니다",
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () => {
                                                  Navigator.pop(context),
                                                },
                                            child: Text('확인')),
                                      ],
                                    );
                                  })
                            }
                        }
                      else
                        {
                          _showMemberExitDialog(
                              teamData['teamName'], teamData['teamMembers'])
                        }
                    },
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  /*관리자 방 나가기 함수*/
  void _showAdminExitDialog(
      String teamName, List<dynamic> adminsList, List<dynamic> membersList) {
    /*관리자 한 명만 남았을 때 팀 삭제*/
    if (membersList.length == 1) {
      showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Text(
                "팀 삭제",
                textAlign: TextAlign.center,
              ),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "팀을 떠나면 팀이 삭제됩니다. 정말로 $teamName을(를) 떠나시겠습니까?",
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
                        child: Text('취소',style: TextStyle(color: Colors.black),)),
                    TextButton(
                        onPressed: () => {
                              HapticFeedback.lightImpact(),
                              widget.teamRef.delete(),
                              widget.myTeamRef.delete(),
                              Navigator.pop(context),
                              Navigator.pop(context),
                              Navigator.pop(context),
                              // Navigator.popUntil(
                              //     context, ModalRoute.withName('/FirstScreen')),
                              // 팀에서 나간 후 RoomScreen으로 이동. 이거 왜 안되노?
                            },
                        child: Text('떠나기',style: TextStyle(color: Colors.black),)),
                  ],
                ),
              ],
            );
          });
    } else {
      adminsList.remove(widget.currentUserRef);
      membersList.remove(widget.currentUserRef);
      showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Text(
                "팀 떠나기",
                textAlign: TextAlign.center,
              ),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "정말로 $teamName을(를) 떠나시겠습니까?",
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
                        child: Text('취소',style: TextStyle(color: Colors.black),)),
                    TextButton(
                        onPressed: () => {
                              HapticFeedback.lightImpact(),
                              widget.teamRef.update({'teamAdmins': adminsList}),
                              widget.teamRef
                                  .update({'teamMembers': membersList}),
                              widget.myTeamRef.delete(),
                              Navigator.pop(context),
                              Navigator.pop(context),
                              Navigator.pop(context),
                              // Navigator.popUntil(
                              //     context, ModalRoute.withName('/FirstScreen')),
                              // 팀에서 나간 후 RoomScreen으로 이동. 이거 왜 안되노?
                            },
                        child: Text('떠나기',style: TextStyle(color: Colors.black),)),
                  ],
                ),
              ],
            );
          });
    }
  }

  /*멤버 방 나가기 함수*/
  void _showMemberExitDialog(String teamName, List<dynamic> membersList) {
    membersList.remove(widget.currentUserRef);
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Text(
              "팀 떠나기",
              textAlign: TextAlign.center,
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "정말로 $teamName을(를) 떠나시겠습니까?",
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
                      child: Text('취소')),
                  TextButton(
                      onPressed: () => {
                            HapticFeedback.lightImpact(),
                            widget.teamRef.update({'teamMembers': membersList}),
                            widget.myTeamRef.delete(),
                            Navigator.pop(context),
                            Navigator.pop(context),
                            Navigator.pop(context),
                            // Navigator.popUntil(
                            //     context, ModalRoute.withName('/FirstScreen')),
                            // 팀에서 나간 후 RoomScreen으로 이동
                          },
                      child: Text('떠나기')),
                ],
              ),
            ],
          );
        });
  }
}
