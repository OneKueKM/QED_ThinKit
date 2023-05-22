import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementAddTap extends StatefulWidget {
  final DocumentReference teamRef;
  final DocumentReference currentUserRef;

  const TeamAnnouncementAddTap(
      {required this.teamRef,
      required this.currentUserRef,
      Key? key})
      : super(key: key);

  @override
  State<TeamAnnouncementAddTap> createState() => _TeamAnnouncementAddTapState();
}

class _TeamAnnouncementAddTapState extends State<TeamAnnouncementAddTap> {
  final TextEditingController announceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '공지 작성',
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
        /*작성 완료 버튼*/
        actions: [
          TextButton(
              onPressed: () {
                /*간단해서 그냥 함수 따로 안만듬*/
                if (announceController.text != '') {
                  final teamsAnnouncement = <String, dynamic>{
                    'announcerRef': widget.currentUserRef,
                    'announceContent': announceController.text,
                    'announceDate': DateTime.now(),
                  };
                  widget.teamRef.collection('Announcement').add(teamsAnnouncement);
                  Navigator.pop(context);
                } else {
                  /*내용을 입력해달라는 토스트 메세지 넣으면 좋을듯*/
                }
              },
              child: Text(
                '완료',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '멤버들과 공유하고 싶은 소식을 남겨보세요.',
            ),
            controller: announceController,
            autofocus: true,
            maxLines: 1000,
          ),
        ),
      ),
    );
  }
}
