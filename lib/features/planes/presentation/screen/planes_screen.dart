import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    // Cargar paciente (y su plan activo, si existe) desde SharedPreferences
    final patientProv = context.read<PatientProvider>();
    await patientProv.loadPatient();
    // Una vez cargado, actualizamos el estado para reconstruir la UI
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Mientras se carga la data, muestra un indicador
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;

    return Scaffold(
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // BANNER "PLAN ACTUAL" (si ya tenemos)
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
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aquí podrías permitir "Desuscribirse" o ir a otra pantalla
                          // patientProv.setActivePlan(null);
                        },
                        child: const Text("Cambiar"),
                      )
                    ],
                  ),
                ),

              // LISTA DE PLANES
              ...AppConstants.plans.map((plan) {
                final bool isSelected = (plan.title == activePlan);
                return _buildPlanCard(
                  context,
                  plan,
                  isSelected: isSelected,
                  onChoose: () {
                    _onChoosePlan(context, plan.title, plan.price);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    PlanData plan, {
    required bool isSelected,
    required VoidCallback onChoose,
  }) {
    final discountText = plan.discount != null ? "Ahorre ${(plan.discount! * 100).toStringAsFixed(0)}%" : null;

    // Estilos condicionales
    final bgColor = isSelected ? const Color(0xFF5B6BF5) : Colors.white;
    final textColor = isSelected ? Colors.white : Colors.black87;
    final greenColor = isSelected ? const Color.fromARGB(255, 144, 246, 116) : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          // CONTENEDOR PRINCIPAL
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  plan.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 30),
                // Precio
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "S/${plan.price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.indigo),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "por mes",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white70 : Colors.indigo),
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
                // Beneficios con checks
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
                        )
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "Escoger Plan",
                      style: TextStyle(fontSize: 16, color: isSelected ? Colors.black : Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),

          // “Ribbon” en la esquina sup. derecha si es el plan activo
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onChoosePlan(BuildContext context, String planTitle, double price) {
    final patientProv = context.read<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;

    // Si ya está suscrito a este plan
    if (activePlan != null && activePlan == planTitle) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ya tienes el plan $planTitle")),
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
