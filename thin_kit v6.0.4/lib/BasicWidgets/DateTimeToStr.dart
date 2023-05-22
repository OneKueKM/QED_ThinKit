String DateTimeToStr(DateTime dateTime) {
  int hour;
  int minute;

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
    if(dateTime.hour == 12){
      hour = dateTime.hour;
    }
    else{
      hour = dateTime.hour - 12;
    }
    minute = dateTime.minute;
    if (0 <= minute && minute < 10) {
      return '오후 $hour:0$minute';
    } else {
      return '오후 $hour:$minute';
    }
  }
}