import 'package:flutter/material.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class MiniCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  const MiniCalendar({
    Key? key,
    required this.selectedDate,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generamos filas para 6 semanas máximo (ej. un mes con 31 días que empieza un jueves)
    final daysGrid = _generateDays();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            _monthYearLabel(selectedDate),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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

          // Hacemos un Column con filas
          Column(
            children: daysGrid.map((week) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: week.map((day) {
                  if (day == null) {
                    return SizedBox(width: 28, height: 28);
                  }
                  final isSelected = (day.day == selectedDate.day && day.month == selectedDate.month && day.year == selectedDate.year);
                  return GestureDetector(
                    onTap: () => onSelectDate(day),
                    child: Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${day.day}",
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF5B6BF5) : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
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

  String _monthYearLabel(DateTime dt) {
    const months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    final m = months[dt.month - 1];
    return "$m ${dt.year}";
  }

  List<List<DateTime?>> _generateDays() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayThisMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final daysInMonth = lastDayThisMonth.day;

    int offset = firstDayOfMonth.weekday - 1; // Lunes=1 => offset = 0, Martes=2 => offset=1...
    if (offset < 0) offset = 6;

    // Crearla como growable
    List<DateTime?> allDays = List.filled(offset, null, growable: true);

    // Agregar días del mes
    for (int i = 1; i <= daysInMonth; i++) {
      allDays.add(DateTime(selectedDate.year, selectedDate.month, i));
    }

    // Rellenar para llegar a múltiplos de 7
    while (allDays.length % 7 != 0) {
      allDays.add(null);
    }

    // Convertir en una matriz 6x7
    List<List<DateTime?>> matrix = [];
    for (int i = 0; i < allDays.length; i += 7) {
      matrix.add(allDays.sublist(i, i + 7));
    }
    return matrix;
  }
}
