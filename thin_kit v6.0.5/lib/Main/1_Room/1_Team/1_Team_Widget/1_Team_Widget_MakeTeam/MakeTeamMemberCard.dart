import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MakeTeamMemberCard extends StatefulWidget {
  String memberProfileUrl;
  String memberName;
  void Function() onTap;
  void Function() onTapCancel;

  MakeTeamMemberCard(
      {required this.memberProfileUrl,
      required this.memberName,
      required this.onTap,
      required this.onTapCancel,
      Key? key})
      : super(key: key);

  @override
  State<MakeTeamMemberCard> createState() => _MakeTeamMemberCardState();
}

class _MakeTeamMemberCardState extends State<MakeTeamMemberCard> {
  bool tapped = false;
  Color backgroundcolor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapped ? _onTapCancel : _onTap,
      child: Container(
        height: 60,
        color: backgroundcolor,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Color(0xfff1efef)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.memberProfileUrl))),
              ),
            ),
            Text(
              widget.memberName,
              style: const TextStyle(
                  fontFamily: 'SFProDisplay', fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    widget.onTap.call();
    tapped = true;
    setState(() {
      backgroundcolor = const Color(0xfff1efef);
    });
  }

  void _onTapCancel() {
    HapticFeedback.lightImpact();
    widget.onTapCancel.call();
    tapped = false;
    setState(() {
      backgroundcolor = Colors.white;
    });
  }
}
