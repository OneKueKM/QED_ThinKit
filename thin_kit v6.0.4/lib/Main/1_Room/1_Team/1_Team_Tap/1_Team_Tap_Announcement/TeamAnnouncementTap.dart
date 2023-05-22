import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Announcement/TeamAnnouncementAddTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_Announcement/TeamAnnouncementDetailTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Widget/1_Team_Widget_Announcement/TeamAnnouncementCard.dart';

import 'package:page_transition/page_transition.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementTap extends StatefulWidget {
  final bool isAdmin;
  final DocumentReference teamRef;
  final DocumentReference currentUserRef;

  const TeamAnnouncementTap(
      {required this.isAdmin,
      required this.teamRef,
      required this.currentUserRef,
      Key? key})
      : super(key: key);

  @override
  State<TeamAnnouncementTap> createState() => _TeamAnnouncementTapState();
}

class _TeamAnnouncementTapState extends State<TeamAnnouncementTap> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '공지',
          style: TextStyle(color: Colors.black),
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
        actions: [
          widget.isAdmin
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TeamAnnouncementAddTap(
                              teamRef: widget.teamRef,
                              currentUserRef: widget.currentUserRef,
                            ))).then((value) {
                      setState(() {});
                    });
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.grey,
                  ))
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(
              thickness: 1,
              height: 1,
              color: Color.fromARGB(255, 222, 222, 222),
            ),
            Expanded(
              child: FutureBuilder(
                future: widget.teamRef
                    .collection('Announcement')
                    .orderBy('announceDate', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  final announceData = snapshot.data?.docs;

                  if (announceData != null) {
                    if (announceData.isNotEmpty) {
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: announceData.length,
                          itemBuilder: (context, index) {
                            return TeamAnnouncementCard(
                                announceContent: announceData[index]['announceContent'],
                                announceDate: announceData[index]['announceDate'].toDate(),
                                announcerRef: announceData[index]['announcerRef'],
                                ontap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamAnnouncementDetailTap(
                                          announcer: announceData[index]['announcerRef'] == widget.currentUserRef
                                              ? true
                                              : false,
                                          announcementRef: announceData[index].reference,
                                          announcerRef: announceData[index]['announcerRef'],
                                          currentUserRef: widget.currentUserRef,
                                        ),
                                      )).then((value) {
                                    setState(() {});
                                  });
                                });
                          });
                    } else {
                      return const Center(
                          child: Text('팀원에게 알릴 공지를 작성해 보세요',
                            style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 15.0,)));
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
