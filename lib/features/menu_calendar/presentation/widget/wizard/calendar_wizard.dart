import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

// Importamos CartProvider para "pagar ahora" (marcar pagado) o “agregar a carrito”
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart'; // Para leer activePlan

const Color kPrimaryColor = Color(0xFF5B6BF5);

class CalendarWizard extends StatelessWidget {
  const CalendarWizard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();

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
// Paso 1 (sin cambios)
class _StepHourAndDayTime extends StatelessWidget {
  const _StepHourAndDayTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    return SingleChildScrollView(
      key: const ValueKey("StepHourAndDayTime"),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _WizardHeader(
            title: "Selecciona Turno y Hora",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 8),
          _DayTimeToggle(
            currentValue: cp.selectedDayTime,
            onChanged: cp.selectDayTime,
          ),
          const SizedBox(height: 12),
          const Text("Horarios disponibles", style: TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          _HourGrid(
            selectedDayTime: cp.selectedDayTime,
            selectedHour: cp.selectedHour,
            onSelectHour: cp.selectHour,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (cp.selectedHour == null) ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Paso 2 (AQUÍ filtramos las categorías según plan)
class _StepCategory extends StatelessWidget {
  const _StepCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();

    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan; // p.e. "Paquete Integral"

    return SingleChildScrollView(
      key: const ValueKey("StepCategory"),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _WizardHeader(
            title: "Tipo de Consulta",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),

          // CONSULTATION TOGGLE -> lo modificamos para recibir activePlan
          _ConsultationToggle(
            currentValue: cp.selectedCategory,
            onChanged: cp.selectCategory,
            activePlan: activePlan,
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (cp.selectedCategory == null) ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Paso 3 (sin cambios)
class _StepDoctor extends StatelessWidget {
  const _StepDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    final docs = cp.filteredDoctors;

    return SingleChildScrollView(
      key: const ValueKey("StepDoctor"),
      padding: const EdgeInsets.all(16),
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
                              const SizedBox(height: 4),
                              Text(
                                "Tarifa: S/ ${doc.consultationFee.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, color: kPrimaryColor),
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
                  onPressed: (cp.selectedDoctor == null) ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Paso 4 (sin cambios)
class _StepConfirm extends StatelessWidget {
  const _StepConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    final dt = cp.newAppointmentDateTime;
    final doc = cp.selectedDoctor;

    return SingleChildScrollView(
      key: const ValueKey("StepConfirm"),
      padding: const EdgeInsets.all(16),
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
                        const SizedBox(height: 4),
                        Text("Tarifa: S/ ${doc.consultationFee.toStringAsFixed(2)}"),
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
                  onPressed: () => _onConfirmPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Confirmar Cita", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onConfirmPressed(BuildContext context) {
    final cp = context.read<CalendarProvider>();
    final newAppt = cp.confirmAppointment();
    if (newAppt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo confirmar la cita.")),
      );
      return;
    }

    final cartProv = context.read<CartProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("¿Cómo deseas proceder?"),
          content: Text(
            "Has reservado una cita con ${newAppt.doctor.name} por S/ ${newAppt.fee.toStringAsFixed(2)}.\n"
            "¿Pagar ahora o seguir comprando?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                cartProv.addToCartAppointment(newAppt);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationScreen(currentIndex: 0),
                  ),
                );
              },
              child: const Text("Seguir Comprando"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                cp.markAppointmentAsPaid(newAppt.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Cita pagada con éxito (S/ ${newAppt.fee.toStringAsFixed(2)})."),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationScreen(currentIndex: 4),
                  ),
                );
              },
              child: const Text("Pagar Ahora"),
            ),
          ],
        );
      },
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
// El toggle con 4 celdas, y LOGICA para habilitar/deshabilitar
class _ConsultationToggle extends StatelessWidget {
  final AppointmentCategory? currentValue;
  final ValueChanged<AppointmentCategory> onChanged;

  final String? activePlan; // "Plan Básico", "Paquete Integral", etc.

  const _ConsultationToggle({
    Key? key,
    this.currentValue,
    required this.onChanged,
    required this.activePlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determina para cada cat si está habilitada
    final bool canPsico = _canUsePsico(activePlan);
    final bool canNutri = _canUseNutri(activePlan);
    final bool canApti = _canUseApti(activePlan);
    final bool canTele = _canUseTele(activePlan);

    final isPsico = (currentValue == AppointmentCategory.psicologico);
    final isNutri = (currentValue == AppointmentCategory.nutricion);
    final isApti = (currentValue == AppointmentCategory.aptitudFisica);
    final isTele = (currentValue == AppointmentCategory.telemedicina);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      children: [
        _TypeCard(
          label: "Apoyo\nPsicológico",
          icon: Icons.self_improvement,
          selected: isPsico,
          enabled: canPsico,
          onTap: () => onChanged(AppointmentCategory.psicologico),
        ),
        _TypeCard(
          label: "Nutrición",
          icon: Icons.restaurant_menu,
          selected: isNutri,
          enabled: canNutri,
          onTap: () => onChanged(AppointmentCategory.nutricion),
        ),
        _TypeCard(
          label: "Aptitud Física",
          icon: Icons.fitness_center,
          selected: isApti,
          enabled: canApti,
          onTap: () => onChanged(AppointmentCategory.aptitudFisica),
        ),
        _TypeCard(
          label: "Telemedicina",
          icon: Icons.video_camera_front,
          selected: isTele,
          enabled: canTele,
          onTap: () => onChanged(AppointmentCategory.telemedicina),
        ),
      ],
    );
  }

  bool _canUsePsico(String? plan) {
    if (plan == null || plan == "Plan Básico") return false;
    if (plan == "Paquete Integral") return true;
    return (plan == "Paquete Apoyo Psicológico");
  }

  bool _canUseNutri(String? plan) {
    if (plan == null || plan == "Plan Básico") return false;
    if (plan == "Paquete Integral") return true;
    return (plan == "Paquete Nutrición");
  }

  bool _canUseApti(String? plan) {
    if (plan == null || plan == "Plan Básico") return false;
    if (plan == "Paquete Integral") return true;
    return (plan == "Paquete Aptitud Física");
  }

  bool _canUseTele(String? plan) {
    if (plan == null || plan == "Plan Básico") return false;
    if (plan == "Paquete Integral") return true;
    return (plan == "Paquete Telemedicina");
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TypeCard con "enabled" = false => color gris, no clickeable
class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _TypeCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? kPrimaryColor : Colors.grey[200];
    final textColor = selected ? Colors.white : Colors.black87;

    // Si no está habilitado => color grisado, no clickeable
    final actualBgColor = enabled ? bgColor : Colors.grey.shade300;
    final actualTextColor = enabled ? textColor : Colors.grey;

    return GestureDetector(
      onTap: enabled ? onTap : null, // si no habilitado => null
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: actualBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: enabled ? (selected ? Colors.white : Colors.black54) : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: actualTextColor,
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
// Resto sin cambios
class _WizardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _WizardHeader({
    Key? key,
    required this.title,
    required this.onBack,
  }) : super(key: key);

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

class _DayTimeToggle extends StatelessWidget {
  final DayTime? currentValue;
  final ValueChanged<DayTime> onChanged;
  const _DayTimeToggle({Key? key, this.currentValue, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isM = (currentValue == DayTime.maniana);
    final isT = (currentValue == DayTime.tarde);
    final isN = (currentValue == DayTime.noche);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ToggleButton(icon: Icons.wb_sunny, label: "Mañana", selected: isM, onTap: () => onChanged(DayTime.maniana)),
        _ToggleButton(icon: Icons.wb_twighlight, label: "Tarde", selected: isT, onTap: () => onChanged(DayTime.tarde)),
        _ToggleButton(icon: Icons.nights_stay, label: "Noche", selected: isN, onTap: () => onChanged(DayTime.noche)),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

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

class _HourGrid extends StatelessWidget {
  final DayTime? selectedDayTime;
  final String? selectedHour;
  final ValueChanged<String> onSelectHour;

  const _HourGrid({Key? key, this.selectedDayTime, this.selectedHour, required this.onSelectHour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final morningSlots = ["8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM"];
    final afternoonSlots = ["12:15 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM"];
    final nightSlots = ["6:30 PM", "7:00 PM", "8:00 PM", "8:30 PM", "9:00 PM"];

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
      itemCount: displaySlots.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
