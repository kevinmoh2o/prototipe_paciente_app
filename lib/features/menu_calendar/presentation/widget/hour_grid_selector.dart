import 'package:flutter/material.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

const Color kPrimaryColor = Color(0xFF5B6BF5);

class HourGridSelector extends StatelessWidget {
  final DayTime? selectedDayTime;
  final String? selectedHour;
  final ValueChanged<String> onSelectHour;

  const HourGridSelector({
    Key? key,
    this.selectedDayTime,
    required this.selectedHour,
    required this.onSelectHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const morningSlots = ["8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM"];
    const afternoonSlots = ["12:15 PM", "1:00 PM", "2:00 PM", "3:00 PM"];
    const nightSlots = ["6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM"];

    List<String> displaySlots;
    switch (selectedDayTime) {
      case DayTime.tarde:
        displaySlots = afternoonSlots;
        break;
      case DayTime.noche:
        displaySlots = nightSlots;
        break;
      case DayTime.maniana:
      default:
        displaySlots = morningSlots;
        break;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displaySlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.5,
      ),
      itemBuilder: (ctx, i) {
        final slot = displaySlots[i];
        final isSelected = (slot == selectedHour);
        return GestureDetector(
          onTap: () => onSelectHour(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ? kPrimaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
