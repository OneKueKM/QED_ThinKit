import 'package:intl/intl.dart';

String ScheduleDateTimeToStr(DateTime dateTime, bool card) {
  int hour;
  int minute;

  if (card) {
    //오전
    if (0 <= dateTime.hour && dateTime.hour <= 11) {
      //시간 저장
      if (dateTime.hour == 0) {
        hour = dateTime.hour + 12;
      } else {
        hour = dateTime.hour;
      }
      minute = dateTime.minute;
      //시간 리턴
      if (0 <= minute && minute < 10) {
        return '오전 $hour:0$minute';
      } else {
        return '오전 $hour:$minute';
      }
    }
    //오후
    else {
      //시간 저장
      if (dateTime.hour == 12) {
        hour = dateTime.hour;
      } else {
        hour = dateTime.hour - 12;
      }
      minute = dateTime.minute;
      //시간 리턴
      if (0 <= minute && minute < 10) {
        return '오후 $hour:0$minute';
      } else {
        return '오후 $hour:$minute';
      }
    }
  }
  else{
    //오전
    if (0 <= dateTime.hour && dateTime.hour <= 11) {
      //시간 저장
      if (dateTime.hour == 0) {
        hour = dateTime.hour + 12;
      } else {
        hour = dateTime.hour;
      }
      minute = dateTime.minute;
      //시간 리턴
      if (0 <= minute && minute < 10) {
        return '${DateFormat("yyyy년 MM월 dd일").format(dateTime)} 오전 $hour:0$minute';
      } else {
        return '${DateFormat("yyyy년 MM월 dd일").format(dateTime)} 오전 $hour:$minute';
      }
    }
    //오후
    else {
      //시간 저장
      if (dateTime.hour == 12) {
        hour = dateTime.hour;
      } else {
        hour = dateTime.hour - 12;
      }
      minute = dateTime.minute;
      //시간 리턴
      if (0 <= minute && minute < 10) {
        return '${DateFormat("yyyy년 MM월 dd일").format(dateTime)} 오후 $hour:0$minute';
      } else {
        return '${DateFormat("yyyy년 MM월 dd일").format(dateTime)} 오후 $hour:$minute';
      }
    }
  }
}
