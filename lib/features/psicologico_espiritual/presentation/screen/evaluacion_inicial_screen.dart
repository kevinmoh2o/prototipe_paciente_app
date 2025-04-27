import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/core/widgets/generic_evaluation_screen.dart';

class EvaluacionInicialScreen extends StatelessWidget {
  const EvaluacionInicialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();
    final activePlan = context.watch<PatientProvider>().patient.activePlan;

    return GenericEvaluationScreen(
      title: 'Evaluación Inicial',
      description: 'Completa este breve cuestionario para conocer tu estado emocional.',
      question1Label: '¿Cómo te sientes hoy?',
      question2Label: '¿Qué es lo que más te preocupa?',
      question3Title: '¿Te sientes ansioso/a últimamente?',
      requireSubscription: true,
      subscriptionCategory: 'Apoyo Psicológico Espiritual',
      hasAccess: () => PlanHelper.userHasAccess(activePlan, 'Apoyo Psicológico Espiritual'),
      onSubmit: (q1, q2, q3) {
        psyProv.setEvaluationAnswer('q1', q1);
        psyProv.setEvaluationAnswer('q2', q2);
        psyProv.setEvaluationAnswer('q3', q3);
        AlertModal.showAlert(
          context,
          color: Colors.green,
          title: '¡Evaluación enviada!',
          description: '',
          detail: '',
          forceDialog: false,
          snackbarDurationInSeconds: 5,
        );
        Navigator.pop(context);
      },
    );
  }
}
