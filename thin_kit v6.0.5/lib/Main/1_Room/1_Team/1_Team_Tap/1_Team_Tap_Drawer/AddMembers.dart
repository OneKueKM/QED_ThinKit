import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../1_Team_Widget/1_Team_Widget_Drawer/AddMemberCard.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddMembers extends StatefulWidget {
  final List<dynamic> membersList;
  final DocumentReference currentUserRef;
  final DocumentReference teamRef;

  const AddMembers(
      {required this.membersList,
      required this.currentUserRef,
      required this.teamRef,
      Key? key})
      : super(key: key);

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  List<dynamic> newMembersList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            widget.currentUserRef.collection('Friends').orderBy('name').get(),
        builder: (context, snapshot) {
          final friendsList = snapshot.data?.docs;

          if (friendsList != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () =>
                      {HapticFeedback.lightImpact(), Navigator.pop(context)},
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      newMembersList.isNotEmpty
                          ? Text(
                              '${newMembersList.length}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          : Container(),
                      IconButton(
                        onPressed: () => {
                          HapticFeedback.lightImpact(),
                          if (newMembersList.isNotEmpty)
                            {
                              HapticFeedback.lightImpact(),
                              _addMembersButton(
                                  widget.membersList, newMembersList),
                              Navigator.pop(context),
                            }
                          else
                            {}
                        },
                        icon: Icon(
                          Icons.add,
                          color: newMembersList.isNotEmpty
                              ? Colors.grey
                              : Colors.grey[200],
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
                title: const Text(
                  '멤버 초대',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('친구'),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: friendsList.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(friendsList[index]['ref'].id)
                                    .get(),
                                builder: (context, snapshot) {
                                  final userData = snapshot.data;

                                  if (userData != null) {
                                    if (widget.membersList
                                        .contains(friendsList[index]['ref'])) {
                                      return Container(
                                        height: 60,
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xfff1efef)),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            userData[
                                                                'userProfile']))),
                                              ),
                                            ),
                                            Text(
                                              userData['userName'],
                                              style: TextStyle(
                                                  color: Colors.grey[300],
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return AddMemberCard(
                                        memberProfileUrl:
                                            userData['userProfile'],
                                        memberName: userData['userName'],
                                        onTap: () {
                                          onTap(friendsList[index]['ref'],
                                              newMembersList);
                                        },
                                        onTapCancel: () {
                                          onTapCancel(friendsList[index]['ref'],
                                              newMembersList);
                                        },
                                      );
                                    }
                                  } else {
                                    return Container();
                                  }
                                });
                          }),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  void _addMembersButton(
      List<dynamic> teamMembers, List<dynamic> newMembersList) {
    int i, j;

    teamMembers.addAll(newMembersList);
    widget.teamRef.update({'teamMembers': teamMembers});

    Map<String, dynamic> myTeamData = <String, dynamic>{
      'favorites': false,
      'teamRef': widget.teamRef,
    };

    for (i = 0; i < newMembersList.length; i++) {
      // 이거 왜 안되냐 씨발
      // widget.teamRef
      //     .collection('Schedules')
      //     .orderBy('startTime', descending: false)
      //     .get()
      //     .then((QuerySnapshot teamSchedules) {
      //   for (j = 0; j < teamSchedules.docs.length; j++) {
      //     Map<String, dynamic> myScheduleData = <String, dynamic>{
      //       'teamRef': widget.teamRef,
      //       'scheduleRef': teamSchedules.docs[j].reference,
      //       'schedulerRef': teamSchedules.docs[j]['schedulerRef'],
      //     };
      //     newMembersList[i].collection('My Schedule').add(myScheduleData);
      //   }
      // });
      newMembersList[i].collection('My Team').add(myTeamData);
    }
  }

  void onTap(DocumentReference friendRef, List<dynamic> newMembers) {
    HapticFeedback.lightImpact();
    newMembers.add(friendRef);
    setState(() {});
  }

  void onTapCancel(DocumentReference friendRef, List<dynamic> newMembers) {
    HapticFeedback.lightImpact();
    newMembers.remove(friendRef);
    setState(() {});
  }
}
