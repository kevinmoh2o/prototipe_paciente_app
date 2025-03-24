import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class CalendarWizard extends StatelessWidget {
  const CalendarWizard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);

    switch (cp.currentStep) {
      case CalendarFlowStep.hourAndDayTime:
        return const _StepHourAndDayTime();
      case CalendarFlowStep.category:
        return const _StepCategory();
      case CalendarFlowStep.doctor:
        return const _StepDoctor();
      case CalendarFlowStep.confirm:
        return const _StepConfirm();
      case CalendarFlowStep.idle:
      default:
        return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _StepHourAndDayTime extends StatelessWidget {
  const _StepHourAndDayTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    return SingleChildScrollView(
      key: const ValueKey("StepHourAndDayTime"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _WizardHeader(
            title: "Selecciona Turno y Hora",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 8),
          // Toggle (mañana, tarde, noche)
          _DayTimeToggle(
            currentValue: cp.selectedDayTime,
            onChanged: (val) => cp.selectDayTime(val),
          ),
          const SizedBox(height: 12),

          // Horarios
          const Text("Mostrando horarios disponibles", style: TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          _HourGrid(
            selectedDayTime: cp.selectedDayTime,
            selectedHour: cp.selectedHour,
            onSelectHour: (h) => cp.selectHour(h),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (cp.selectedHour == null || cp.selectedDayTime == null) ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Un toggle simple para DayTime
class _DayTimeToggle extends StatelessWidget {
  final DayTime? currentValue;
  final ValueChanged<DayTime> onChanged;
  const _DayTimeToggle({Key? key, this.currentValue, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isManiana = currentValue == DayTime.maniana;
    final isTarde = currentValue == DayTime.tarde;
    final isNoche = currentValue == DayTime.noche;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ToggleButton(
          icon: Icons.wb_sunny,
          label: "Mañana",
          selected: isManiana,
          onTap: () => onChanged(DayTime.maniana),
        ),
        _ToggleButton(
          icon: Icons.wb_twighlight,
          label: "Tarde",
          selected: isTarde,
          onTap: () => onChanged(DayTime.tarde),
        ),
        _ToggleButton(
          icon: Icons.nights_stay,
          label: "Noche",
          selected: isNoche,
          onTap: () => onChanged(DayTime.noche),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleButton({Key? key, required this.icon, required this.label, required this.selected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? Colors.white : Colors.black54),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grilla de horas
class _HourGrid extends StatelessWidget {
  final DayTime? selectedDayTime;
  final String? selectedHour;
  final ValueChanged<String> onSelectHour;
  const _HourGrid({
    Key? key,
    this.selectedDayTime,
    this.selectedHour,
    required this.onSelectHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // define horarios según el dayTime
    final morningSlots = ["8:30 AM", "8:45 AM", "9:00 AM", "9:15 AM", "9:30 AM", "9:45 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"];
    final afternoonSlots = ["12:15 PM", "1:00 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM", "4:00 PM"];
    final nightSlots = ["6:30 PM", "6:45 PM", "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM", "9:00 PM", "9:30 PM"];

    List<String> displaySlots;
    if (selectedDayTime == null) {
      // Por defecto, mostrar la mañana
      displaySlots = morningSlots;
    } else {
      switch (selectedDayTime!) {
        case DayTime.maniana:
          displaySlots = morningSlots;
          break;
        case DayTime.tarde:
          displaySlots = afternoonSlots;
          break;
        case DayTime.noche:
          displaySlots = nightSlots;
          break;
      }
    }

    // Hazlo scrollable en caso de muchas horas
    return GridView.builder(
      itemCount: displaySlots.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final slot = displaySlots[index];
        final isSelected = slot == selectedHour;
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

// ─────────────────────────────────────────────────────────────────────────────
class _StepCategory extends StatelessWidget {
  const _StepCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);

    return SingleChildScrollView(
      key: const ValueKey("StepCategory"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _WizardHeader(
            title: "Tipo de Consulta",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),
          _ConsultationToggle(
            currentValue: cp.selectedCategory,
            onChanged: (cat) => cp.selectCategory(cat),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cp.selectedCategory == null ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Toggle Apoyo Psicológico, Nutrición, Telemedicina
class _ConsultationToggle extends StatelessWidget {
  final AppointmentCategory? currentValue;
  final ValueChanged<AppointmentCategory> onChanged;
  const _ConsultationToggle({Key? key, this.currentValue, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPsico = currentValue == AppointmentCategory.psicologico;
    final isNutri = currentValue == AppointmentCategory.nutricion;
    final isTele = currentValue == AppointmentCategory.telemedicina;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _TypeCard(
          label: "Apoyo\nPsicológico",
          icon: Icons.self_improvement,
          selected: isPsico,
          onTap: () => onChanged(AppointmentCategory.psicologico),
        ),
        _TypeCard(
          label: "Nutrición",
          icon: Icons.restaurant_menu,
          selected: isNutri,
          onTap: () => onChanged(AppointmentCategory.nutricion),
        ),
        _TypeCard(
          label: "Telemedicina",
          icon: Icons.video_camera_front,
          selected: isTele,
          onTap: () => onChanged(AppointmentCategory.telemedicina),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TypeCard({Key? key, required this.label, required this.icon, required this.selected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.black54),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _StepDoctor extends StatelessWidget {
  const _StepDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    final docs = cp.filteredDoctors;

    return SingleChildScrollView(
      key: const ValueKey("StepDoctor"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _WizardHeader(
            title: "Selecciona Especialista",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),
          if (docs.isEmpty)
            const Text("No hay doctores disponibles para esta categoría.")
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final doc = docs[i];
                final isSelected = (cp.selectedDoctor == doc);
                return GestureDetector(
                  onTap: () => cp.selectDoctor(doc),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.white,
                      border: Border.all(
                        color: isSelected ? kPrimaryColor : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(doc.profileImage),
                          radius: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(doc.specialty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text("${doc.rating} (${doc.reviewsCount} Reviews)", style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, color: kPrimaryColor)
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cp.selectedDoctor == null ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _StepConfirm extends StatelessWidget {
  const _StepConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    final dt = cp.newAppointmentDateTime;
    final doc = cp.selectedDoctor;

    return SingleChildScrollView(
      key: const ValueKey("StepConfirm"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _WizardHeader(
            title: "Confirmar Cita",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),
          if (dt == null || doc == null)
            const Text("Faltan datos para confirmar.")
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fecha/Hora: ${_formatDate(dt)} - ${_formatHour(dt)}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(doc.profileImage),
                      radius: 24,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(doc.specialty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => cp.confirmAppointment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Confirmar Cita", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    final m = months[dt.month - 1];
    return "${dt.day} de $m ${dt.year}";
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour;
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = (h >= 12) ? "p.m." : "a.m.";
    final h12 = (h % 12 == 0) ? 12 : h % 12;
    return "$h12:$min $ampm";
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _WizardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _WizardHeader({Key? key, required this.title, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: onBack,
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
