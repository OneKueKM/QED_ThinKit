import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class InfoPolicy extends StatefulWidget {
  const InfoPolicy({super.key});

  @override
  State<InfoPolicy> createState() => _InfoPolicyState();
}

class _InfoPolicyState extends State<InfoPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(TablerIcons.chevron_left),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            '개인정보 처리방침',
            style: TextStyle(
                fontFamily: 'SFProText',
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17),
          ),
        ),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                children: [
                  Container(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    height: 70,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Processing...',
                              style: TextStyle(
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                ]),
          ),
        ));
  }
}
