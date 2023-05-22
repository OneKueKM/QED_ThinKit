import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 현재 시간을 불러오기 위한 패키지

/* 현재 시간을 불러와서 한글로 월/일/요일을 출력해주는 클래스 DataAppBar */
class DataAppBar {
  var now = DateTime.now(); // 현재 시간을 불러와서 저장하는 변수 now

/* 현재 시간을 월/일 으로 출력해주는 함수 getSystemTime */
  String getSystemTime() {
    return DateFormat("M월 d일").format(now);
  }

/* 현재 날짜의 요일을 번호로 바꾸어주는 함수 getweekDay */
  int getweekDay() {
    return now.weekday; //월요일 : 1, 화요일 : 2, ....
  }

/* 함수 getweekDay으로부터 받은 날짜의 번호 => 요일을 한글로 출력하는 함수 getKoreanWeek */
  String getKoreanWeek(int week) {
    switch (week) {
      case 1:
        return "월요일";
      case 2:
        return "화요일";
      case 3:
        return "수요일";
      case 4:
        return "목요일";
      case 5:
        return "금요일";
      case 6:
        return "토요일";
      case 7:
        return "일요일";
      default:
        return "<ERROR>";
    }
  }
}
