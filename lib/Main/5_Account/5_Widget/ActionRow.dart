import 'package:flutter/material.dart';

/* 내부 패키지 */
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/MembershipTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/NotificationTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/SecurityTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/BroadcastTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/SettingsTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/APITap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/TipsTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/DatabaseTap.dart';

/* 외부 패키지 */
import 'package:flutter/services.dart'; //Haptic Feedback
import 'package:tabler_icons/tabler_icons.dart';
import 'package:page_transition/page_transition.dart';

class ActionRow extends StatefulWidget {
  const ActionRow({super.key});

  @override
  State<ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<ActionRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.broadcast),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () => {
                      HapticFeedback.lightImpact(),
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const BroadcastTap(),
                              childCurrent: const BroadcastTap()))
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '소식',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.bulb),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () => {
                      HapticFeedback.lightImpact(),
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const TipsTap(),
                              childCurrent: const TipsTap()))
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '도움',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.credit_card),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => const MembershipTap());
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '멤버쉽',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.api),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () => {
                      HapticFeedback.lightImpact(),
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const APITap(),
                              childCurrent: const APITap()))
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '연동',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.bell_ringing_2),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => const NotificationTap());
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '알림',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.server_bolt),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () => {
                      HapticFeedback.lightImpact(),
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const DatabaseTap(),
                              childCurrent: const DatabaseTap()))
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '연구실',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.shield_check),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => const SecurityTap());
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '보안',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  width: 50,
                  child: IconButton(
                    icon: const Icon(TablerIcons.settings),
                    color: Colors.black,
                    iconSize: 33,
                    onPressed: () => {
                      HapticFeedback.lightImpact(),
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const SettingsTap()))
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '설정',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
