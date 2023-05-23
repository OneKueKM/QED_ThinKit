import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_MakeTeam/MakeTeamMemberCard.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_MakeTeam/MakeTeamSetting.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MakeTeamsTap extends StatefulWidget {
  List<dynamic> friendsDataList;
  DocumentReference currentUserRef;
  String currentUserName;

  MakeTeamsTap(
      {required this.friendsDataList,
      required this.currentUserRef,
      required this.currentUserName,
      Key? key})
      : super(key: key);

  @override
  State<MakeTeamsTap> createState() => _MakeTeamsTapState();
}

class _MakeTeamsTapState extends State<MakeTeamsTap> {
  final TextEditingController teamNameController = TextEditingController();

  late List<dynamic> teamAdmins;
  late List<dynamic> teamMembers;

  @override
  void initState() {
    super.initState();
    teamAdmins = [widget.currentUserRef];
    teamMembers = [widget.currentUserRef];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () =>
              {HapticFeedback.lightImpact(), Navigator.pop(context)},
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.grey,
            size: 30,
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              teamMembers.length > 1
                  ? Text(
                      '${teamMembers.length - 1}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  : Container(),
              IconButton(
                onPressed: () => {
                  if (teamMembers.length > 1)
                    {
                      HapticFeedback.lightImpact(),
                      Future.delayed(const Duration(milliseconds: 400), () {
                        _makeTeamButton(
                            teamNameController.text == ''
                                ? '${widget.currentUserName}의 팀'
                                : teamNameController.text,
                            teamAdmins,
                            teamMembers);
                      }),
                      Navigator.pop(context),
                    }
                  else
                    {
                      /*멤버가 2명 이상이어야 팀을 만들 수 있다는 토스트 메세지? 넣으면 좋을듯*/
                    }
                },
                icon: Icon(
                  Icons.add,
                  color:
                      teamMembers.length > 1 ? Colors.grey : Colors.grey[200],
                  size: 30,
                ),
              ),
            ],
          ),
        ],
        title: const Text(
          '멤버 선택',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MakeTeamSetting(
              teamNameController: teamNameController,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('친구'),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.friendsDataList.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                      future: widget.friendsDataList[index]['ref'].get(),
                      builder: (context, snapshot) {
                        final friendsData = snapshot.data;

                        if (friendsData != null) {
                          return MakeTeamMemberCard(
                            memberProfileUrl: friendsData['userProfile'],
                            memberName: widget.friendsDataList[index]['name'],
                            onTap: () {
                              onTap(widget.friendsDataList[index]['ref'],
                                  teamMembers);
                            },
                            onTapCancel: () {
                              onTapCancel(widget.friendsDataList[index]['ref'],
                                  teamMembers);
                            },
                          );
                        } else {
                          return Container();
                        }
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makeTeamButton(
      String teamName, List<dynamic> teamAdmins, List<dynamic> teamMembers) {
    int i;
    Map<String, dynamic> myTeamData;

    final teamData = <String, dynamic>{
      'teamName': teamName,
      'teamAdmins': teamAdmins,
      'teamMembers': teamMembers,
    };

    FirebaseFirestore.instance
        .collection('Teams')
        .add(teamData)
        .then((DocumentReference teamRef) {
      myTeamData = <String, dynamic>{
        'favorites': false,
        'teamRef': teamRef,
      };
      for (i = 0; i < teamMembers.length; i++) {
        teamMembers[i].collection('MyTeam').add(myTeamData);
      }
    });
  }

  void onTap(DocumentReference friendRef, List<dynamic> teamMembers) {
    HapticFeedback.lightImpact();
    teamMembers.add(friendRef);
    setState(() {});
  }

  void onTapCancel(DocumentReference friendRef, List<dynamic> teamMembers) {
    HapticFeedback.lightImpact();
    teamMembers.remove(friendRef);
    setState(() {});
  }
}
