// lib/features/nutricion/presentation/screen/evaluacion_nutricional_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/core/widgets/generic_evaluation_screen.dart';

class EvaluacionNutricionalScreen extends StatelessWidget {
  const EvaluacionNutricionalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriProv = context.watch<NutricionProvider>();
    final activePlan = context.watch<PatientProvider>().patient.activePlan;

    return GenericEvaluationScreen(
      title: "Evaluación Nutricional",
      description: 'Responde estas preguntas para conocer tus hábitos alimenticios.',
      question1Label: '¿Cuántas comidas completas haces al día?',
      question2Label: '¿Incluyes frutas/verduras en tus comidas?',
      question3Title: '¿Consumes bebidas azucaradas con frecuencia?',
      requireSubscription: true,
      subscriptionCategory: 'Nutrición',
      hasAccess: () => PlanHelper.userHasAccess(activePlan, 'Nutrición'),
      onSubmit: (q1, q2, q3) {
        nutriProv.setEvalAnswer('q1', q1);
        nutriProv.setEvalAnswer('q2', q2);
        nutriProv.setEvalAnswer('q3', q3);
        AlertModal.showAlert(
          context,
          color: Colors.green,
          title: 'Evaluación registrada',
          description: '',
          detail: 'Detalle opcional',
          forceDialog: false,
          snackbarDurationInSeconds: 5,
        );
        Navigator.pop(context);
      },
    );
  }
}
