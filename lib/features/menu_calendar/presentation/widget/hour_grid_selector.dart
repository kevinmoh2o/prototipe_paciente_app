import 'package:flutter/material.dart';

class HourGridSelector extends StatelessWidget {
  final List<String> hours;
  final String? selectedHour;
  final ValueChanged<String> onSelectHour;

  const HourGridSelector({
    Key? key,
    required this.hours,
    required this.selectedHour,
    required this.onSelectHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hours.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final h = hours[index];
        final bool isSelected = (h == selectedHour);
        return GestureDetector(
          onTap: () => onSelectHour(h),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF5B6BF5) : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              h,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
