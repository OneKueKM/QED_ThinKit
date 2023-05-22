import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qed_app_thinkit/BasicWidgets/ScheduleDateTimeToStr.dart';

import '../../../../../BasicWidgets/DateTimeToStr.dart';

import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TeamScheduleEditTap extends StatefulWidget {
  final String scheduleTitle;
  final String scheduleLoaction;
  final String scheduleContent;
  final DateTime startTime;
  final DateTime endTime;
  final DocumentReference scheduleRef;

  TeamScheduleEditTap(
      {required this.scheduleTitle,
      required this.scheduleLoaction,
      required this.scheduleContent,
      required this.startTime,
      required this.endTime,
      required this.scheduleRef,
      Key? key})
      : super(key: key);

  @override
  State<TeamScheduleEditTap> createState() => _TeamScheduleEditTapState();
}

class _TeamScheduleEditTapState extends State<TeamScheduleEditTap> {
  late TextEditingController titleController;
  late TextEditingController locationController;
  late TextEditingController contentController;

  late DateTime startTime;
  late DateTime endTime;

  bool startTapped = false;
  bool endTapped = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.scheduleTitle);
    locationController = TextEditingController(text: widget.scheduleLoaction);
    contentController = TextEditingController(text: widget.scheduleContent);

    startTime = DateTime(
      widget.startTime.year,
      widget.startTime.month,
      widget.startTime.day,
      widget.startTime.hour,
    );

    endTime = DateTime(
      widget.endTime.year,
      widget.endTime.month,
      widget.endTime.day,
      widget.endTime.hour,
    );
  }

  Widget build(BuildContext context) {
    final bool ok; // 종료 시간이 시작시간 보다 뒤인지 확인하는 변수
    if (endTime.month < startTime.month) {
      ok = false;
    } else if (endTime.month == startTime.month &&
        endTime.day < startTime.day) {
      ok = false;
    } else if (endTime.month == startTime.month &&
        endTime.day == startTime.day &&
        endTime.hour < startTime.hour) {
      ok = false;
    } else if (endTime.month == startTime.month &&
        endTime.day == startTime.day &&
        endTime.hour == startTime.hour &&
        endTime.minute < startTime.minute) {
      ok = false;
    } else {
      ok = true;
    }

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                HapticFeedback.lightImpact(),
                if (ok)
                  {
                    UpdateSchedule(),
                    Navigator.pop(context),
                  }
                else
                  {
                    showDialog(
                        context: context,
                        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            //Dialog Main Title
                            title: const Text(
                              "일정을 저장할 수 없음",
                              textAlign: TextAlign.center,
                            ),
                            //
                            content: const Text(
                              "시작 날짜는 종료 날짜 이전이어야 합니다",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => {
                                        Navigator.pop(context),
                                      },
                                  child: const Text('확인')),
                            ],
                          );
                        }),
                  }
              },
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.check_sharp,
                color: Colors.black,
              ),
            ), // 일정 추가 버튼
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                '수정',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () =>
                    {HapticFeedback.lightImpact(), Navigator.pop(context)},
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _TitleInputField(
                    titleController: titleController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('시작'),
                      TextButton(
                        onPressed: () {
                          if (startTapped) {
                            setState(() {
                              startTapped = false;
                            });
                          } else {
                            setState(() {
                              startTapped = true;
                              endTapped = false;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffefeff0)),
                        child: Text(
                          ScheduleDateTimeToStr(startTime, false),
                          style: TextStyle(
                            color: startTapped ? Colors.red : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Start Time Picker*/
                  Visibility(
                    visible: startTapped,
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (value) {
                          if (value != startTime) {
                            setState(() {
                              startTime = value;
                              if (value.hour == 23) {
                                endTime = DateTime(
                                  value.year,
                                  value.month,
                                  value.day + 1,
                                );
                              } else {
                                endTime = DateTime(
                                  value.year,
                                  value.month,
                                  value.day,
                                  value.hour + 1,
                                );
                              }
                            });
                          }
                        },
                        initialDateTime: startTime,
                        minuteInterval: 5,
                      ),
                    ),
                  ),
                  /*종료 시간 버튼*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('종료'),
                      TextButton(
                        onPressed: () {
                          if (endTapped) {
                            setState(() {
                              endTapped = false;
                            });
                          } else {
                            setState(() {
                              endTapped = true;
                              startTapped = false;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffefeff0)),
                        child: Text(
                          ScheduleDateTimeToStr(endTime, false),
                          style: TextStyle(
                              color: endTapped ? Colors.red : Colors.black,
                              decoration: ok
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough),
                        ),
                      ),
                    ],
                  ),
                  /*Start Time Picker*/
                  Visibility(
                    visible: endTapped,
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (value) {
                          if (value != endTime) {
                            setState(() {
                              endTime = value;
                            });
                          }
                        },
                        initialDateTime: endTime,
                        minuteInterval: 5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xfff1efef),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.alarm),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ), // 내용 입력 필드
                  ),
                  _LocInputField(
                    locationController: locationController,
                  ),
                  _ContentInputField(
                    contentController: contentController,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void UpdateSchedule() {
    final teamschedule = <String, dynamic>{
      "title": titleController.text == '' ? '제목 없음' : titleController.text,
      // 입력 없으면 제목 없음으로 저장
      "startTime": startTime,
      "endTime": endTime,
      "location": locationController.text,
      "content": contentController.text,
    };
    widget.scheduleRef.update(teamschedule);
  }
}

class _TitleInputField extends StatelessWidget {
  final TextEditingController titleController;

  const _TitleInputField({required this.titleController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff1efef),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.title_outlined),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '제목',
                ),
                controller: titleController,
                autofocus: true,
                minLines: 1,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocInputField extends StatelessWidget {
  final TextEditingController locationController;

  const _LocInputField({required this.locationController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfff1efef),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '장소',
                ),
                controller: locationController,
                minLines: 1,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentInputField extends StatelessWidget {
  final TextEditingController contentController;

  const _ContentInputField({required this.contentController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfff1efef),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.notes_outlined),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '내용',
                ),
                controller: contentController,
                //keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
              ),
            ),
          ],
        ),
      ), // 내용 입력 필드
    );
  }
}
