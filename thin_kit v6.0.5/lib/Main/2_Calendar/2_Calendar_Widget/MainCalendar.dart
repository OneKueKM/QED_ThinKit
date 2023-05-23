import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final CalendarFormat calendarFormat;
  final List<dynamic> Function(DateTime)? eventLoader;

  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
    this.calendarFormat = CalendarFormat.month,
    this.eventLoader
  });

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
      daysOfWeekHeight: 35,
      rowHeight: 50,
      headerStyle: const HeaderStyle(
        headerMargin: EdgeInsets.all(10.0),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          color: Colors.red,
        ),
        formatButtonVisible: false,
        leftChevronVisible: false, rightChevronVisible: false,
      ),

      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,
        todayDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        selectedDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
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
