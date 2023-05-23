import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final CalendarFormat calendarFormat;
  final List<dynamic> Function(DateTime)? eventLoader;

  MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
    this.calendarFormat = CalendarFormat.month,
    this.eventLoader
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      calendarFormat: calendarFormat,

      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) => isSameDay(date, selectedDate),
          // date.year == selectedDate.year &&
          // date.month == selectedDate.month &&
          // date.day == selectedDate.day,


      focusedDay: selectedDate,
      firstDay: DateTime(2000, 1, 1),
      lastDay: DateTime(2100, 1, 1),


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

      daysOfWeekHeight: 30,
      daysOfWeekStyle: DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.grey[400])),

      eventLoader: eventLoader,

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
