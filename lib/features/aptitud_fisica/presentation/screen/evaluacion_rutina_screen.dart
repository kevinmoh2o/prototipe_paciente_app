// lib/features/aptitud_fisica/presentation/screen/evaluacion_rutina_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/core/widgets/generic_evaluation_screen.dart';

class EvaluacionRutinaScreen extends StatelessWidget {
  const EvaluacionRutinaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();
    final activePlan = context.watch<PatientProvider>().patient.activePlan;

    return GenericEvaluationScreen(
      title: 'Evaluación de Rutina',
      description: 'Cuéntanos sobre tu actividad física y limitaciones.',
      question1Label: '¿Cuántas veces a la semana haces ejercicio?',
      question2Label: '¿Tienes alguna restricción médica?',
      question3Title: '¿Sientes fatiga al caminar distancias cortas?',
      requireSubscription: true,
      subscriptionCategory: 'Aptitud Física',
      hasAccess: () => PlanHelper.userHasAccess(activePlan, 'Aptitud Física'),
      onSubmit: (q1, q2, q3) {
        aptProv.setEvaluationAnswer('q1', q1);
        aptProv.setEvaluationAnswer('q2', q2);
        aptProv.setEvaluationAnswer('q3', q3);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evaluación guardada')),
        );
        Navigator.pop(context);
      },
    );
  }
}
