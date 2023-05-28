import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:flutter/services.dart'; //Haptic Feedback

class FriendDetail extends StatefulWidget {
  DocumentSnapshot<Map<String, dynamic>> userInfo;
  DocumentSnapshot<Map<String, dynamic>> myUserInfo;

  FriendDetail({Key? key, required this.userInfo, required this.myUserInfo})
      : super(key: key);

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  late bool isHeartFilled;

  @override
  void initState() {
    super.initState();
    debugPrint(widget.userInfo.id);
    isHeartFilled = widget.myUserInfo['favorites'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(children: [
            Form(
              child: Column(
                children: [
                  Container(
                    height: 350,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image:
                                NetworkImage(widget.userInfo['userProfile']))),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 4,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 222, 222, 222),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isHeartFilled == true)
                          SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.myUserInfo.reference
                                    .update({'favorites': false});
                                setState(() {
                                  isHeartFilled = false;
                                });
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    TablerIcons.heart_filled,
                                    size: 20,
                                    color: Color.fromARGB(255, 239, 45, 110),
                                  ),
                                  Text('  친한 친구 해제',
                                      style: TextStyle(
                                          fontFamily: 'SFProText',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        if (isHeartFilled == false)
                          SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.myUserInfo.reference
                                    .update({'favorites': true});
                                setState(() {
                                  isHeartFilled = true;
                                });
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    TablerIcons.heart,
                                    size: 20,
                                    color: Color.fromARGB(255, 239, 45, 110),
                                  ),
                                  Text('  친한 친구 등록',
                                      style: TextStyle(
                                          fontFamily: 'SFProText',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                            child: GestureDetector(
                          onTap: () async {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('진짜 삭제할거야?'),
                                      content: GestureDetector(
                                        onTap: null,
                                        child: const Text('임시'),
                                      ));
                                });
                          },
                          child: SizedBox(
                            height: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  TablerIcons.eraser,
                                  size: 25,
                                  color: Color.fromARGB(255, 88, 88, 88),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Uri telephoneURL = Uri.parse(
                                      'tel:${widget.userInfo['telephoneNum']}');
                                  if (await launchUrl(telephoneURL)) {
                                  } else {
                                    Get.snackbar("오류 발생", "전화 연결 불가");
                                  }
                                },
                                child: const Icon(TablerIcons.phone, size: 22),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                width: 7,
                                thickness: 1.5,
                                indent: 9,
                                endIndent: 9,
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          widget.userInfo['email'])
                                      // ignore: avoid_print
                                      .then((value) => print('Copied'));
                                },
                                child: const Icon(TablerIcons.mail_opened,
                                    size: 20),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                width: 7,
                                thickness: 1.5,
                                indent: 9,
                                endIndent: 9,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(TablerIcons.brand_instagram,
                                    size: 22),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                width: 7,
                                thickness: 1.5,
                                indent: 9,
                                endIndent: 9,
                              ),
                              const Icon(TablerIcons.brand_telegram, size: 22)
                            ],
                          ),
                        ),
                        const Divider(
                            height: 30,
                            color: Color.fromARGB(255, 188, 188, 188),
                            thickness: 1),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '이름',
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () async {
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('이름 바꾸기'),
                                        content: TextField(
                                          autofocus: true,
                                          controller: TextEditingController(
                                              text: widget.myUserInfo['name']),
                                          onSubmitted: (String text) {
                                            widget.myUserInfo.reference
                                                .update({'name': text});
                                            if (!mounted) return;
                                            Navigator.pop(context);
                                          },
                                          textInputAction: TextInputAction.send,
                                        ),
                                      );
                                    });
                              },
                              child: SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      TablerIcons.writing_sign,
                                      size: 18,
                                      color: Color.fromARGB(255, 100, 100, 100),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 15),
                            Text(
                              widget.userInfo['userName'],
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              '한 줄 소개',
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 15),
                            Text(
                              widget.userInfo['userExplain'],
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
