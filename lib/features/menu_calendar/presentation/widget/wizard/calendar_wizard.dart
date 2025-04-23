// lib/features/menu_calendar/presentation/widget/wizard/calendar_wizard.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

const Color kPrimaryColor = Color(0xFF5B6BF5);

/// ---------------------------------------------------------------------------
///  W I Z A R D   R O O T
/// ---------------------------------------------------------------------------
class CalendarWizard extends StatelessWidget {
  const CalendarWizard({super.key});

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
      default:
        return const SizedBox.shrink(); // idle
    }
  }
}

/// ---------------------------------------------------------------------------
///  P A S O  1  –  T U R N O   &   H O R A
/// ---------------------------------------------------------------------------
class _StepHourAndDayTime extends StatelessWidget {
  const _StepHourAndDayTime({super.key});

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _WizardHeader(title: 'Selecciona Turno y Hora', onBack: cp.backStep),
          const SizedBox(height: 8),
          _DayTimeToggle(
            currentValue: cp.selectedDayTime,
            onChanged: cp.selectDayTime,
          ),
          const SizedBox(height: 12),
          const Text('Horarios disponibles', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          _HourGrid(
            selectedDayTime: cp.selectedDayTime,
            selectedHour: cp.selectedHour,
            onSelectHour: cp.selectHour,
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
            enabled: cp.selectedHour != null,
            label: 'Siguiente',
            onTap: cp.nextStep,
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  P A S O  2  –  C A T E G O R Í A
/// ---------------------------------------------------------------------------
class _StepCategory extends StatelessWidget {
  const _StepCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    final patientProv = context.watch<PatientProvider>();

    final String? activePlan = patientProv.patient.activePlan;
    final bool unrestricted = cp.allAppointments.isEmpty; // primera reserva

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _WizardHeader(title: 'Tipo de Consulta', onBack: cp.backStep),
          const SizedBox(height: 16),
          _ConsultationToggle(
            currentValue: cp.selectedCategory,
            onChanged: cp.selectCategory,
            activePlan: activePlan,
            unrestricted: unrestricted,
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
            enabled: cp.selectedCategory != null,
            label: 'Siguiente',
            onTap: cp.nextStep,
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  P A S O  3  –  D O C T O R
/// ---------------------------------------------------------------------------
class _StepDoctor extends StatelessWidget {
  const _StepDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    final PatientModel patient = context.watch<PatientProvider>().patient;
    final String? plan = context.watch<PatientProvider>().patient.activePlan;
    final docs = cp.filteredDoctors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _WizardHeader(title: 'Selecciona Especialista', onBack: cp.backStep),
          const SizedBox(height: 16),
          if (docs.isEmpty)
            const Text('No hay doctores disponibles para esta categoría.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final doc = docs[i];
                final bool selected = cp.selectedDoctor == doc;

                double fee = doc.consultationFee;
                //if (plan == 'Paquete Telemedicina') fee = 70;
                //if (plan == 'Paquete Apoyo Psicológico' || plan == 'Paquete Nutrición' || plan == 'Paquete Aptitud Física') fee = 50;
                if (patient.counterPAqueteIntegral! > 0 && plan == 'Paquete Integral') fee = 0;

                return GestureDetector(
                  onTap: () => cp.selectDoctor(doc),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected ? kPrimaryColor.withOpacity(.1) : Colors.white,
                      border: Border.all(color: selected ? kPrimaryColor : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundImage: AssetImage(doc.profileImage), radius: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(doc.specialty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('Tarifa: S/ ${fee.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        if (selected) const Icon(Icons.check_circle, color: kPrimaryColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          _PrimaryButton(
            enabled: cp.selectedDoctor != null,
            label: 'Siguiente',
            onTap: cp.nextStep,
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  P A S O  4  –  C O N F I R M A R
/// ---------------------------------------------------------------------------
class _StepConfirm extends StatelessWidget {
  const _StepConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    final dt = cp.newAppointmentDateTime;
    final doc = cp.selectedDoctor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _WizardHeader(title: 'Confirmar Cita', onBack: cp.backStep),
          const SizedBox(height: 16),
          if (dt == null || doc == null)
            const Text('Faltan datos para confirmar.')
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha/Hora: ${_fmtDate(dt)} - ${_fmtHour(dt)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(backgroundImage: AssetImage(doc.profileImage), radius: 24),
                    const SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(doc.specialty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('Tarifa: S/ ${doc.consultationFee.toStringAsFixed(2)}'),
                    ])
                  ],
                ),
              ],
            ),
          const SizedBox(height: 24),
          _PrimaryButton(
            enabled: true,
            label: 'Confirmar Cita',
            onTap: () => _onConfirmPressed(context),
          ),
        ],
      ),
    );
  }

  void _onConfirmPressed(BuildContext context) {
    final cp = context.read<CalendarProvider>();
    //final pp = context.read<PatientProvider>();
    final pp = Provider.of<PatientProvider>(context, listen: false);
    final newAppt = cp.confirmAppointment();
    if (newAppt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo confirmar la cita.")),
      );
      return;
    }

    final cartProv = context.read<CartProvider>();

    pp.subtract();

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

  String _fmtDate(DateTime d) {
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return '${d.day} de ${months[d.month - 1]} ${d.year}';
  }

  String _fmtHour(DateTime d) {
    final h = d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final ap = h >= 12 ? 'p.m.' : 'a.m.';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:$m $ap';
  }
}

/// ---------------------------------------------------------------------------
///  C O N S U L T A   T O G G L E
/// ---------------------------------------------------------------------------
class _ConsultationToggle extends StatelessWidget {
  final AppointmentCategory? currentValue;
  final ValueChanged<AppointmentCategory> onChanged;
  final String? activePlan;
  final bool unrestricted;

  const _ConsultationToggle({
    required this.currentValue,
    required this.onChanged,
    required this.activePlan,
    required this.unrestricted,
  });

  bool _isEnabled(String cat) {
    if (unrestricted) return true; // primera reserva
    return switch (cat) {
      'psico' => activePlan == 'Paquete Integral' || activePlan == 'Paquete Apoyo Psicológico',
      'nutri' => activePlan == 'Paquete Integral' || activePlan == 'Paquete Nutrición',
      'apti' => activePlan == 'Paquete Integral' || activePlan == 'Paquete Aptitud Física',
      'tele' => activePlan == 'Paquete Integral' || activePlan == 'Paquete Telemedicina',
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      childAspectRatio: 1.1,
      children: [
        _TypeCard(
          label: 'Apoyo\nPsicológico',
          icon: Icons.self_improvement,
          selected: currentValue == AppointmentCategory.psicologico,
          enabled: _isEnabled('psico'),
          onTap: () => onChanged(AppointmentCategory.psicologico),
        ),
        _TypeCard(
          label: 'Nutrición',
          icon: Icons.restaurant_menu,
          selected: currentValue == AppointmentCategory.nutricion,
          enabled: _isEnabled('nutri'),
          onTap: () => onChanged(AppointmentCategory.nutricion),
        ),
        _TypeCard(
          label: 'Aptitud Física',
          icon: Icons.fitness_center,
          selected: currentValue == AppointmentCategory.aptitudFisica,
          enabled: _isEnabled('apti'),
          onTap: () => onChanged(AppointmentCategory.aptitudFisica),
        ),
        _TypeCard(
          label: 'Telemedicina',
          icon: Icons.video_camera_front,
          selected: currentValue == AppointmentCategory.telemedicina,
          enabled: _isEnabled('tele'),
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
  final bool enabled;
  final VoidCallback onTap;

  const _TypeCard({required this.label, required this.icon, required this.selected, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final base = AnimatedContainer(
      width: 300,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: enabled ? (selected ? kPrimaryColor : Colors.grey[200]) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: enabled ? (selected ? Colors.white : Colors.black54) : Colors.grey),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(color: enabled ? (selected ? Colors.white : Colors.black87) : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
    );

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Stack(children: [
        base,
        if (!enabled)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.amber.shade700, borderRadius: BorderRadius.circular(10)),
              child: Row(children: const [
                Icon(Icons.diamond, size: 12, color: Colors.white),
                SizedBox(width: 2),
                Text('Mejorar', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))
              ]),
            ),
          )
      ]),
    );
  }
}

/// ---------------------------------------------------------------------------
///  S W I T C H   T U R N O
/// ---------------------------------------------------------------------------
class _DayTimeToggle extends StatelessWidget {
  final DayTime? currentValue;
  final ValueChanged<DayTime> onChanged;
  const _DayTimeToggle({this.currentValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget btn(String l, IconData i, DayTime v) => _Toggle(label: l, icon: i, selected: currentValue == v, onTap: () => onChanged(v));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btn('Mañana', Icons.wb_sunny, DayTime.maniana),
        btn('Tarde', Icons.wb_twighlight, DayTime.tarde),
        btn('Noche', Icons.nights_stay, DayTime.noche),
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _Toggle({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          Icon(icon, size: 20, color: selected ? Colors.white : Colors.black54),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  G R I D   H O R A R I A
/// ---------------------------------------------------------------------------
class _HourGrid extends StatelessWidget {
  final DayTime? selectedDayTime;
  final String? selectedHour;
  final ValueChanged<String> onSelectHour;
  const _HourGrid({this.selectedDayTime, this.selectedHour, required this.onSelectHour});

  @override
  Widget build(BuildContext context) {
    const morning = ['8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM'];
    const afternoon = ['12:15 PM', '1:00 PM', '2:00 PM', '3:00 PM'];
    const night = ['6:30 PM', '7:00 PM', '8:00 PM', '8:30 PM'];

    final slots = switch (selectedDayTime) {
      DayTime.tarde => afternoon,
      DayTime.noche => night,
      _ => morning,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.5,
      ),
      itemBuilder: (_, i) {
        final slot = slots[i];
        final bool sel = slot == selectedHour;
        return GestureDetector(
          onTap: () => onSelectHour(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? kPrimaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(slot, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
///  B O T Ó N   P R I N C I P A L
/// ---------------------------------------------------------------------------
class _PrimaryButton extends StatelessWidget {
  final bool enabled;
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.enabled, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
          child: ElevatedButton(
              onPressed: enabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(label, style: const TextStyle(fontSize: 16))),
        )
      ]);
}

/// ---------------------------------------------------------------------------
///  H E A D E R   C O M Ú N
/// ---------------------------------------------------------------------------
class _WizardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _WizardHeader({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) => Row(children: [
        IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_ios)),
        Expanded(
          child: Center(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(width: 40),
      ]);
}
