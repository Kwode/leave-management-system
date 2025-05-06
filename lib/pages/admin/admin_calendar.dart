import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAdminPage extends StatefulWidget {
  const CalendarAdminPage({super.key});

  @override
  State<CalendarAdminPage> createState() => _CalendarAdminPageState();
}

class _CalendarAdminPageState extends State<CalendarAdminPage> {
  late final ValueNotifier<List<String>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample events: keys are dates, values are lists of event descriptions.
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 6, 4): ['Leave: Annual Leave - Dr. Smith'],
    DateTime.utc(2024, 6, 7): ['Public Holiday: Independence Day'],
    DateTime.utc(2024, 6, 14): ['Department Holiday'],
    DateTime.utc(2024, 6, 18): ['Academic Event: Graduation Ceremony'],
    DateTime.utc(2024, 6, 22): ['Leave: Sick Leave - Prof. Johnson'],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Widget _buildEventList() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _selectedEvents,
      builder: (context, events, _) {
        if (events.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No events for selected day.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.event, color: Color.fromARGB(255, 0, 34, 61)),
              title: Text(
                events[index],
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 34, 61)),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Admin Calendar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color.fromARGB(255, 0, 34, 61),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TableCalendar<String>(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 34, 61),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 101, 195),
                  shape: BoxShape.circle,
                ),
                todayDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 1, 168, 151),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 34, 61),
                  borderRadius: BorderRadius.circular(5),
                ),
                formatButtonTextStyle: const TextStyle(color: Colors.white),
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 34, 61),
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                }
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 240, 245),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildEventList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}