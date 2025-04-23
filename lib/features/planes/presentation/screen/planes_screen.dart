// lib/features/planes/presentation/screen/planes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class PlanesScreen extends StatefulWidget {
  final int initialIndex;
  const PlanesScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<PlanesScreen> createState() => _PlanesScreenState();
}

class _PlanesScreenState extends State<PlanesScreen> {
  bool _loading = true;
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: .82,
    )..addListener(() {
        final p = _pageController.page?.round() ?? 0;
        if (p != _currentPage) setState(() => _currentPage = p);
      });
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    await context.read<PatientProvider>().loadPatient();
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;
    final plans = AppConstants.plans;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activePlan != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text("Tu plan actual: $activePlan", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(onPressed: () {}, child: const Text("Cambiar")),
                    ],
                  ),
                ),
              const Text("Nuestros Planes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Desliza horizontalmente para ver todos los planes y elige el que mejor se ajuste a tus necesidades.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(plans.length, (i) {
                  final sel = i == _currentPage;
                  return GestureDetector(
                    onTap: () => _pageController.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: sel ? 14 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: sel ? Colors.blue : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: plans.length,
                  itemBuilder: (_, i) {
                    final p = plans[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildPlanCard(
                        p,
                        isSelected: p.title == activePlan,
                        onChoose: () => _onChoosePlan(context, p.title, p.price),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(PlanData plan, {required bool isSelected, required VoidCallback onChoose}) {
    final discount = plan.discount != null ? "Ahorre ${(plan.discount! * 100).toStringAsFixed(0)}%" : null;
    final bg = isSelected ? plan.color : Colors.white;
    final txt = isSelected ? Colors.white : Colors.black87;
    final accent = isSelected ? plan.color.withOpacity(.7) : plan.color;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  Icon(plan.icon, size: 30, color: isSelected ? Colors.white : plan.color),
                  const SizedBox(height: 10),
                  Text(plan.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: txt)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("S/${plan.price.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : plan.color)),
                      const SizedBox(width: 4),
                      Text("por mes",
                          style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white70 : plan.color.withOpacity(.8))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(plan.description, textAlign: TextAlign.justify, style: TextStyle(fontSize: 14, color: txt)),
                  const SizedBox(height: 10),
                  ...plan.benefits.map((b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.check, color: isSelected ? Colors.white : plan.color, size: 18),
                          const SizedBox(width: 6),
                          Expanded(child: Text(b, style: TextStyle(fontSize: 14, color: txt))),
                        ]),
                      )),
                  const SizedBox(height: 16),
                  if (discount != null) ...[
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.white.withOpacity(.1) : plan.color.withOpacity(.9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(discount),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: onChoose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.white.withOpacity(.85) : plan.color,
                        foregroundColor: isSelected ? plan.color : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isSelected ? "Seleccionado" : "Escoger Plan", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), topRight: Radius.circular(12)),
                  ),
                  child: Row(children: const [
                    Icon(Icons.check, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text("Plan Actual", style: TextStyle(color: Colors.white, fontSize: 15)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onChoosePlan(BuildContext ctx, String planTitle, double price) {
    final patientProv = ctx.read<PatientProvider>();
    final currentPlan = patientProv.patient.activePlan;
    final change = currentPlan != null && currentPlan != planTitle;

    if (currentPlan == planTitle) {
      AlertModal.showAlert(ctx,
          color: Colors.green, title: 'Ya tienes el plan:', description: planTitle, detail: '', forceDialog: false, snackbarDurationInSeconds: 5);
      return;
    }

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(change ? "Cambiar Plan" : "Escoger Plan"),
        content: Text(change
            ? "Actualmente tienes el plan $currentPlan.\n¿Deseas cambiarte al plan $planTitle (S/$price al mes)?"
            : "¿Deseas suscribirte al plan $planTitle con un costo de S/$price al mes?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              patientProv.setActivePlan(planTitle);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(change ? "¡Has cambiado tu plan a $planTitle!" : "¡Te suscribiste al plan $planTitle!")));
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
