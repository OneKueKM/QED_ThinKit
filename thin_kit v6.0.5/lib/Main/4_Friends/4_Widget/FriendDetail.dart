import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendDetail extends StatefulWidget {
  DocumentSnapshot<Map<String, dynamic>> userInfo;
  DocumentSnapshot<Map<String, dynamic>> myUserInfo;

  FriendDetail({Key? key, required this.userInfo, required this.myUserInfo})
      : super(key: key);

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  late bool isStarFilled;

  @override
  void initState() {
    super.initState();
    debugPrint(widget.userInfo.id);
    isStarFilled = widget.myUserInfo['favorites'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(33))),
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '연락하기',
                          style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '알림 보내기',
                          style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  )),
            ],
          )
        ],
        content: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 400,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 285,
                            height: 285,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(22)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: const Offset(0, 7))
                                ],
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        widget.userInfo['userProfile']))),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.userInfo['userName'],
                            style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            widget.userInfo['userID'],
                            style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 133, 133, 133)),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                              width: 250,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: RichText(
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    strutStyle: const StrutStyle(fontSize: 17),
                                    text: TextSpan(
                                        text: widget.userInfo['userExplain'],
                                        style: const TextStyle(
                                          fontFamily: 'SFProText',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        )),
                                  ))
                                ],
                              ))
                        ],
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}
