import 'package:flutter/material.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class MiniCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final List<AppointmentModel> allAppointments;

  const MiniCalendar({
    Key? key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.allAppointments,
  }) : super(key: key);

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  late DateTime _currentMonthYear;

  @override
  void initState() {
    super.initState();
    _currentMonthYear = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final daysGrid = _generateDays(_currentMonthYear);
    final today = DateTime.now();
    final todayNoTime = DateTime(today.year, today.month, today.day);

    return Column(
      children: [
        // Encabezado
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _goToPreviousMonth,
              icon: const Icon(Icons.chevron_left, color: Colors.white),
            ),
            Text(
              _monthYearLabel(_currentMonthYear),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _goToNextMonth,
              icon: const Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Cabecera de días
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("LU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("MA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("MI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("JU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("VI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("SA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("DO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),

        const SizedBox(height: 8),

        // Días en grilla
        Column(
          children: daysGrid.map((week) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: week.map((day) {
                if (day == null) {
                  return const SizedBox(width: 35, height: 45);
                }

                final dayNoTime = DateTime(day.year, day.month, day.day);
                final isSelected = _isSameDay(day, widget.selectedDate);
                final isPast = dayNoTime.isBefore(todayNoTime);

                // cuántas citas hay ese día
                final eventCount = widget.allAppointments.where((a) => _isSameDay(a.dateTime, day)).length;

                // Estilos distintos si es pasado
                final bgColor = isSelected
                    ? Colors.white
                    : isPast
                        ? Colors.grey[400] // Fecha pasada
                        : Colors.transparent;
                final textColor = isSelected
                    ? const Color(0xFF5B6BF5)
                    : isPast
                        ? Colors.white
                        : Colors.white;

                return GestureDetector(
                  onTap: () {
                    // Evitar seleccionar días pasados
                    if (!isPast) {
                      widget.onSelectDate(day);
                      if (day.month != _currentMonthYear.month || day.year != _currentMonthYear.year) {
                        setState(() {
                          _currentMonthYear = DateTime(day.year, day.month);
                        });
                      }
                    }
                  },
                  child: SizedBox(
                    width: 35,
                    height: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${day.day}",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        _buildEventDots(eventCount),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<List<DateTime?>> _generateDays(DateTime baseMonth) {
    final firstDayOfMonth = DateTime(baseMonth.year, baseMonth.month, 1);
    final lastDayThisMonth = DateTime(baseMonth.year, baseMonth.month + 1, 0);
    final daysInMonth = lastDayThisMonth.day;

    int offset = firstDayOfMonth.weekday - 1; // Lunes=1 => offset=0
    if (offset < 0) offset = 6;

    List<DateTime?> allDays = List.filled(offset, null, growable: true);
    for (int i = 1; i <= daysInMonth; i++) {
      allDays.add(DateTime(baseMonth.year, baseMonth.month, i));
    }
    while (allDays.length % 7 != 0) {
      allDays.add(null);
    }

    // Partir en semanas
    List<List<DateTime?>> matrix = [];
    for (int i = 0; i < allDays.length; i += 7) {
      matrix.add(allDays.sublist(i, i + 7));
    }
    return matrix;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return (a.year == b.year && a.month == b.month && a.day == b.day);
  }

  String _monthYearLabel(DateTime dt) {
    const months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    final m = months[dt.month - 1];
    return "$m ${dt.year}";
  }

  Widget _buildEventDots(int count) {
    if (count <= 0) return const SizedBox(height: 4);
    final maxDots = (count > 3) ? 3 : count;
    return SizedBox(
      height: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxDots, (index) {
          return Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  void _goToNextMonth() {
    setState(() {
      final nextMonth = DateTime(_currentMonthYear.year, _currentMonthYear.month + 1);
      _currentMonthYear = nextMonth;
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      final prevMonth = DateTime(_currentMonthYear.year, _currentMonthYear.month - 1);
      _currentMonthYear = prevMonth;
    });
  }
}
