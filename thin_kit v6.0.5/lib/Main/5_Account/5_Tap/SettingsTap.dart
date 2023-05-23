import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

class SettingsTap extends StatefulWidget {
  const SettingsTap({super.key});

  @override
  State<SettingsTap> createState() => _SettingsTapState();
}

class _SettingsTapState extends State<SettingsTap> {
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
            'Settings',
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
