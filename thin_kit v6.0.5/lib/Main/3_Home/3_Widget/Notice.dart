import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30,
        child: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Container(
              height: 15,
              width: 10,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/gifs/redLiveDot.gif')),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              '1개의 새로운 알림이 있어요!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )));
  }
}
