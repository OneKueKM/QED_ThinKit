import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class TeamCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  const TeamCalendar(
      {required this.onDaySelected, required this.selectedDate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: selectedDate,
      firstDay: DateTime(2000, 1, 1),
      lastDay: DateTime(2100, 1, 1),

      /*Calendar Settings*/
      locale: 'ko_kr',
      calendarFormat: CalendarFormat.week,
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
      daysOfWeekHeight: 35,
      rowHeight: 50,
      headerStyle: const HeaderStyle(
        headerMargin: EdgeInsets.all(10.0),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          color: Colors.red,
        ),
        titleCentered: false,
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
      ),
      calendarStyle: const CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}
