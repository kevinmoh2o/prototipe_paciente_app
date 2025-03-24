import 'package:flutter/material.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class DayTimeToggle extends StatelessWidget {
  final DayTime? currentValue;
  final ValueChanged<DayTime> onChanged;

  const DayTimeToggle({
    Key? key,
    required this.currentValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelectedManiana = (currentValue == DayTime.maniana);
    final isSelectedTarde = (currentValue == DayTime.tarde);
    final isSelectedNoche = (currentValue == DayTime.noche);

    return ToggleButtons(
      borderRadius: BorderRadius.circular(20),
      fillColor: const Color(0xFF5B6BF5),
      selectedColor: Colors.white,
      color: Colors.grey[600],
      isSelected: [isSelectedManiana, isSelectedTarde, isSelectedNoche],
      onPressed: (index) {
        if (index == 0) onChanged(DayTime.maniana);
        if (index == 1) onChanged(DayTime.tarde);
        if (index == 2) onChanged(DayTime.noche);
      },
      constraints: const BoxConstraints(minWidth: 80, minHeight: 40),
      children: const [
        Icon(Icons.wb_sunny), // Mañana
        Icon(Icons.wb_twighlight), // Tarde (icono "atardecer" o similar)
        Icon(Icons.nights_stay), // Noche
      ],
    );
  }
}
