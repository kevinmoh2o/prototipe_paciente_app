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
  late DateTime _currentMonthYear; // guarda el primer día del mes que estamos visualizando

  @override
  void initState() {
    super.initState();
    // inicia en el mes del selectedDate, en día 1
    _currentMonthYear = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    // Generamos la grilla
    final daysGrid = _generateDays(_currentMonthYear);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Encabezado con flechas de navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _goToPreviousMonth,
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              Text(
                _monthYearLabel(_currentMonthYear),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: _goToNextMonth,
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Encabezado de días
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

          // Filas de días
          Column(
            children: daysGrid.map((week) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: week.map((day) {
                  // day=null => espacio en blanco
                  if (day == null) {
                    return const SizedBox(width: 35, height: 45);
                  }

                  // Check si está seleccionado
                  final isSelected = (day.year == widget.selectedDate.year &&
                      day.month == widget.selectedDate.month &&
                      day.day == widget.selectedDate.day);

                  // Calcula cuántas citas hay ese día
                  final dayAppointments = widget.allAppointments
                      .where((a) => _isSameDay(a.dateTime, day))
                      .toList();
                  final eventCount = dayAppointments.length;

                  return GestureDetector(
                    onTap: () {
                      widget.onSelectDate(day);
                      // Podríamos hacer que si el mes difiere, actualice la vista
                      if (day.month != _currentMonthYear.month || day.year != _currentMonthYear.year) {
                        setState(() {
                          _currentMonthYear = DateTime(day.year, day.month);
                        });
                      }
                    },
                    child: SizedBox(
                      width: 35,
                      height: 45, // un poco más alto para los puntitos
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circulo del día
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${day.day}",
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF5B6BF5) : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
                              ),
                            ),
                          ),
                          // PUNTITOS de eventos
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
      ),
    );
  }

  // Avanza un mes
  void _goToNextMonth() {
    setState(() {
      final nextMonth = DateTime(_currentMonthYear.year, _currentMonthYear.month + 1);
      _currentMonthYear = nextMonth;
    });
  }

  // Retrocede un mes
  void _goToPreviousMonth() {
    setState(() {
      final prevMonth = DateTime(_currentMonthYear.year, _currentMonthYear.month - 1);
      _currentMonthYear = prevMonth;
    });
  }

  // Muestra "Marzo 2025"
  String _monthYearLabel(DateTime dt) {
    const months = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    final m = months[dt.month - 1];
    return "$m ${dt.year}";
  }

  // Genera una matriz de 6 filas x 7 columnas
  List<List<DateTime?>> _generateDays(DateTime baseMonth) {
    final firstDayOfMonth = DateTime(baseMonth.year, baseMonth.month, 1);
    final lastDayThisMonth = DateTime(baseMonth.year, baseMonth.month + 1, 0);
    final daysInMonth = lastDayThisMonth.day;

    // offset: cuántos "huecos" antes del primer lunes
    int offset = firstDayOfMonth.weekday - 1; // Lunes=1 => offset =0, Martes=2 =>1...
    if (offset < 0) offset = 6;

    // Llenamos con null los espacios previos
    List<DateTime?> allDays = List.filled(offset, null, growable: true);

    // Agregar días del mes
    for (int i = 1; i <= daysInMonth; i++) {
      allDays.add(DateTime(baseMonth.year, baseMonth.month, i));
    }

    // Rellenar para llegar a múltiplos de 7 (p.e. 28, 35, 42)
    while (allDays.length % 7 != 0) {
      allDays.add(null);
    }

    // Dividir en filas de 7
    List<List<DateTime?>> matrix = [];
    for (int i = 0; i < allDays.length; i += 7) {
      matrix.add(allDays.sublist(i, i + 7));
    }
    return matrix;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Hasta 3 puntitos según la cantidad de eventos
  Widget _buildEventDots(int count) {
    if (count == 0) return const SizedBox(height: 4);
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
}
