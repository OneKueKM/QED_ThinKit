import 'package:flutter/material.dart';

import 'package:qed_app_thinkit/BasicWidgets/DateTimeToStr.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementCard extends StatelessWidget {
  String announceContent;
  DateTime announceDate;
  DocumentReference announcerRef;
  void Function() ontap;

  TeamAnnouncementCard(
      {required this.announceContent,
      required this.announceDate,
      required this.announcerRef,
      required this.ontap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: announcerRef.get(),
      builder: (context, snapshot) {
        final announcerData = snapshot.data;
        if (announcerData != null) {
          return GestureDetector(
            onTap: ontap,
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 222, 222, 222),
                          width: 1.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(color: Color(0xfff1efef)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(announcerData['userProfile'])),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(announcerData['userName'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 17.0,
                                        overflow: TextOverflow.ellipsis)),
                                Text(
                                  DateTimeToStr(announceDate),
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10,),
                    child: Text(
                      announceContent, //스트링 받아올 때 엔터도 여기에 한 줄로 보이도록 하는게 좋을거 같음
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 17.0,
                          overflow: TextOverflow.ellipsis),
                    ),
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
}
