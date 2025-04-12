import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class PlanesScreen extends StatefulWidget {
  const PlanesScreen({Key? key}) : super(key: key);

  @override
  State<PlanesScreen> createState() => _PlanesScreenState();
}

class _PlanesScreenState extends State<PlanesScreen> {
  bool _loading = true;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
    _pageController = PageController(
      viewportFraction: 0.82, // Cada tarjeta ocupa ~82% del ancho
    );

    // Escuchamos cambios de página para actualizar _currentPage
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage);
      }
    });
  }

  Future<void> _loadPatientData() async {
    final patientProv = context.read<PatientProvider>();
    await patientProv.loadPatient(); // Carga plan actual, etc.
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;
    final plans = AppConstants.plans; // Tus planes

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Scroll vertical para todo el contenido de la pantalla
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner: Plan actual
              if (activePlan != null)
                Container(
                  width: double.infinity,
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
                        child: Text(
                          "Tu plan actual: $activePlan",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Lógica para cambiar plan, etc.
                        },
                        child: const Text("Cambiar"),
                      ),
                    ],
                  ),
                ),

              // Título y subtítulo
              const Text(
                "Nuestros Planes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Desliza horizontalmente para ver todos los planes y elige el que mejor se ajuste a tus necesidades.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Puntos (indicador) arriba del carrusel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(plans.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Al pulsar un punto, animamos el PageView a esa página
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (index == _currentPage) ? Colors.blue : Colors.grey.shade400,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Carrusel de planes con altura fija
              SizedBox(
                height: 400, // Ajusta la altura del carrusel a tu gusto
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: plans.length,
                  itemBuilder: (ctx, index) {
                    final plan = plans[index];
                    final bool isSelected = (plan.title == activePlan);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildPlanCard(
                        context,
                        plan,
                        isSelected: isSelected,
                        onChoose: () {
                          _onChoosePlan(context, plan.title, plan.price);
                        },
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

  // Construye la tarjeta de cada plan
  Widget _buildPlanCard(
    BuildContext context,
    PlanData plan, {
    required bool isSelected,
    required VoidCallback onChoose,
  }) {
    final discountText = (plan.discount != null) ? "Ahorre ${(plan.discount! * 100).toStringAsFixed(0)}%" : null;

    final bgColor = isSelected ? const Color(0xFF5B6BF5) : Colors.white;
    final textColor = isSelected ? Colors.white : Colors.black87;
    final greenColor = isSelected ? const Color.fromARGB(255, 144, 246, 116) : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Para evitar overflow interno si el contenido del plan es muy alto:
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Scroll interno dentro de la tarjeta
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    plan.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "S/${plan.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "por mes",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white70 : Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Descripción
                  Text(
                    plan.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                  const SizedBox(height: 20),

                  // Beneficios
                  Column(
                    children: plan.benefits.map((b) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: greenColor, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              b,
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Botón discount
                  if (discountText != null)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.white.withOpacity(0.1) : Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: Text(discountText),
                    ),
                  const SizedBox(height: 10),

                  // Botón Escoger Plan
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: onChoose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.white.withOpacity(0.85) : const Color(0xFF324BB8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Escoger Plan",
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // "Ribbon" si es el plan actual
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "Plan Actual",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Igual a tu lógica anterior
  void _onChoosePlan(BuildContext context, String planTitle, double price) {
    final patientProv = context.read<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;

    if (activePlan != null && activePlan == planTitle) {
      AlertModal.showAlert(
        context,
        color: Colors.green,
        title: 'Ya tienes el plan : ',
        description: planTitle,
        detail: 'Detalle opcional',
        forceDialog: false,
        snackbarDurationInSeconds: 5,
      );
      return;
    }

    final isChanging = (activePlan != null && activePlan != planTitle);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isChanging ? "Cambiar Plan" : "Escoger Plan"),
        content: isChanging
            ? Text(
                "Actualmente tienes el plan $activePlan.\n"
                "¿Deseas cambiarte al plan $planTitle (S/$price al mes)?",
              )
            : Text(
                "¿Deseas suscribirte al plan $planTitle con un costo de S/$price al mes?",
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              patientProv.setActivePlan(planTitle);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isChanging ? "¡Has cambiado tu plan a $planTitle!" : "¡Te suscribiste al plan $planTitle!",
                  ),
                ),
              );
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
