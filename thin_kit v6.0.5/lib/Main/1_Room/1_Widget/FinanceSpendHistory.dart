import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';

class FinanceSpendHistory extends StatelessWidget {
  int usedMoney;
  int leftMoney;

  FinanceSpendHistory(
      {super.key, required this.usedMoney, required this.leftMoney});

  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
              child: Text(
                "${now.month}월 이용금액",
                style: const TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Text(
                "$usedMoney원",
                style: const TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 27,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: LinearProgressIndicator(
                semanticsValue: "sex",
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                value: (usedMoney + leftMoney == 0)
                    ? 0
                    : (usedMoney / (usedMoney + leftMoney)),
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                      '잔여: $leftMoney',
                      style: const TextStyle(
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black),
                    ),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ],
    );
  }
}
