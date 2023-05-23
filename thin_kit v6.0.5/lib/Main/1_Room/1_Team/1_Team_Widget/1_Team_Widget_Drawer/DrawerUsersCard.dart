import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerUsersCard extends StatefulWidget {
  bool admin;
  DocumentReference teamRef;
  DocumentReference draweUserRef;
  String drawerUserProfile;
  String drawerUserName;
  List<dynamic> membersList;

  DrawerUsersCard({this.admin = false,
    required this.teamRef,
    required this.draweUserRef,
    required this.drawerUserName,
    required this.drawerUserProfile,
    required this.membersList,
    Key? key})
      : super(key: key);

  @override
  State<DrawerUsersCard> createState() => _DrawerUsersCardState();
}

class _DrawerUsersCardState extends State<DrawerUsersCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Color(0xfff1efef)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.drawerUserProfile))),
              ),
            ),
            Text(
              widget.drawerUserName,
              style: const TextStyle(
                  fontFamily: 'SFProDisplay', fontWeight: FontWeight.w500),
            ),
          ],
        ),
        // /*어드민만 버튼 보임*/
        // widget.admin
        //     ? IconButton(
        //     onPressed: () {
        //       /*멤버 삭제 함수*/
        //       widget.membersList.remove(widget.draweUserRef);
        //       showDialog(
        //           context: context,
        //           //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        //           barrierDismissible: true,
        //           builder: (context) {
        //             return AlertDialog(
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10.0)),
        //               //Dialog Main Title
        //               title: Text(
        //                 "멤버 추방",
        //                 textAlign: TextAlign.center,
        //               ),
        //               //
        //               content: Column(
        //                 mainAxisSize: MainAxisSize.min,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   Text(
        //                     "정말로 ${widget.drawerUserName}님을(를) 추방하시겠습니까?",
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ],
        //               ),
        //               actions: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                   children: [
        //                     TextButton(
        //                         onPressed: () =>
        //                         {
        //                           Navigator.pop(context),
        //                         },
        //                         child: Text('취소')),
        //                     TextButton(
        //                         onPressed: () =>
        //                         {
        //                           HapticFeedback.lightImpact(),
        //                           Future.delayed(
        //                               const Duration(milliseconds: 500),
        //                                   () {
        //                                 widget.teamRef.update({'teamMembers': widget.membersList});
        //                               }),
        //                           Navigator.pop(context),
        //                           Navigator.pop(context),
        //                         },
        //                         child: Text('확인')),
        //                   ],
        //                 ),
        //               ],
        //             );
        //           });
        //     },
        //     icon: Icon(Icons.person_off))
        //     : Container(),
      ],
    );
  }
}
