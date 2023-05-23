import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';

class spendHistory extends StatefulWidget {
  spendHistory({super.key});

  var f = NumberFormat("###.0#", "en_US");

  @override
  State<spendHistory> createState() => _spendHistoryState();
}

class _spendHistoryState extends State<spendHistory> {
  int spendLimit = 500000;
  int spentMoney = 322200;
  double spentRate = 0.644;
  double spentPercent = 64.4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  '지출내역',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                '3월 : $spentMoney',
                style: const TextStyle(
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Color.fromARGB(255, 197, 0, 0)),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CupertinoProgressBar(
                value: spentRate,
                valueColor: const Color.fromARGB(255, 255, 122, 122),
              ),
            ),
            Container(
                height: 20,
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$spendLimit',
                      style: const TextStyle(
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Colors.grey),
                    ),
                  ],
                )),
            const SizedBox(height: 10)
          ],
        ),
      ],
    );
  }
}
