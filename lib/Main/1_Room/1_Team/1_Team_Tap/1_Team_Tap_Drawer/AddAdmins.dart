import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../1_Team_Widget/1_Team_Widget_Drawer/AddMemberCard.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddAdmins extends StatefulWidget {
  List<dynamic> adminsList;
  List<dynamic> membersList;
  DocumentReference currentUserRef;
  DocumentReference teamRef;

  AddAdmins(
      {required this.adminsList,
      required this.membersList,
      required this.currentUserRef,
        required this.teamRef,
      Key? key})
      : super(key: key);

  @override
  State<AddAdmins> createState() => _AddAdminsState();
}

class _AddAdminsState extends State<AddAdmins> {
  List<dynamic> newAdminsList = [];

  @override
  Widget build(BuildContext context) {
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
              newAdminsList.isNotEmpty
                  ? Text(
                '${newAdminsList.length}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
                  : Container(),
              IconButton(
                onPressed: () => {
                  HapticFeedback.lightImpact(),
                  if (newAdminsList.isNotEmpty)
                    {
                      HapticFeedback.lightImpact(),
                      /*관리자 추가 함수*/
                      _addAdminsButton(widget.adminsList, newAdminsList),
                      Navigator.pop(context),
                    }
                  else
                    {}
                },
                icon: Icon(
                  Icons.add,
                  color: newAdminsList.isNotEmpty ? Colors.grey : Colors.grey[200],
                  size: 30,
                ),
              ),
            ],
          )
        ],
        title: const Text(
          '관리자 추가',
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
              child: Text('멤버'),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.membersList.length,
                  itemBuilder: (context, index) {
                    /*멤버 카드 위젯*/
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.membersList[index].id)
                            .get(),
                        builder: (context, snapshot) {
                          final userData = snapshot.data;

                          if (userData != null) {
                            /*내 프로필은 표사 안함*/
                            if (widget.membersList[index] ==
                                widget.currentUserRef) {
                              return Container();
                            }
                            /*이미 관리자면 따로 표시*/
                            if (widget.adminsList
                                .contains(widget.membersList[index])) {
                              return Container(
                                height: 60,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            border: Border.all(
                                                color: Color(0xfff1efef)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    userData['userProfile']))),
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
                                memberProfileUrl: userData['userProfile'],
                                memberName: userData['userName'],
                                onTap: () {
                                  onTap(
                                      widget.membersList[index], newAdminsList);
                                },
                                onTapCancel: () {
                                  onTapCancel(
                                      widget.membersList[index], newAdminsList);
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
  }

  void _addAdminsButton(List<dynamic> teamAdmins, List<dynamic> newAdminsList) {
    teamAdmins.addAll(newAdminsList);
    widget.teamRef.update({'teamAdmins': teamAdmins});
  }

  void onTap(DocumentReference memberRef, List<dynamic> newAdminsList) {
    HapticFeedback.lightImpact();
    newAdminsList.add(memberRef);
    setState(() {});
  }

  void onTapCancel(DocumentReference memberRef, List<dynamic> newAdminsList) {
    HapticFeedback.lightImpact();
    newAdminsList.remove(memberRef);
    setState(() {});
  }
}
