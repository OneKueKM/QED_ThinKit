import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final CalendarFormat calendarFormat;
  final List<dynamic> Function(DateTime)? eventLoader;

  const Calendar(
      {super.key,
      required this.onDaySelected,
      required this.selectedDate,
      this.calendarFormat = CalendarFormat.month,
      this.eventLoader});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: selectedDate,
      firstDay: DateTime(2000, 1, 1),
      lastDay: DateTime(2100, 1, 1),
      eventLoader: eventLoader,

      /*Calendar Settings*/
      locale: 'ko_kr',
      calendarFormat: calendarFormat,
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) => isSameDay(date, selectedDate),
      weekendDays: const [DateTime.sunday],
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          weekendStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          )),

      /*Calendar Decoration Area*/
      daysOfWeekHeight: 30,
      rowHeight: 50,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        headerMargin: EdgeInsets.all(0),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.0,
          color: Colors.black,
        ),
        formatButtonVisible: false,
        leftChevronVisible: true,
        rightChevronVisible: true,
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,
        todayDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 255, 77, 64),
        ),
        selectedDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        todayTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        selectedTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        defaultTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
