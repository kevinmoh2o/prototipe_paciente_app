// lib/features/psicologico_espiritual/presentation/screen/grupos_apoyo_screen.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/widgets/dialogs/upgrade_dialog.dart';

import 'package:paciente_app/core/widgets/facebook_style_post_list.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';

class GruposApoyoScreen extends StatelessWidget {
  const GruposApoyoScreen({Key? key}) : super(key: key);

  void _promptUpgrade(BuildContext ctx) {
    DialogHelper.showUpgradeDialog(
      context: ctx,
      categoryTitle: 'Apoyo Psicológico Espiritual',
      description: 'Elige el plan que mejor se adapte a ti para participar en los grupos:',
    );
  }

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();
    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;

    final allowed = PlanHelper.userHasAccess(activePlan, 'Apoyo Psicológico Espiritual');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos de Apoyo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: FacebookStylePostList(
        posts: psyProv.posts,
        onReactToPost: (i, type) => allowed ? psyProv.reactToPost(i, type) : _promptUpgrade(context),
        onAddCommentToPost: (i, text) => allowed ? psyProv.addCommentToPost(i, text) : _promptUpgrade(context),
        onReactToComment: (pIdx, cIdx) => allowed ? psyProv.reactToComment(pIdx, cIdx) : _promptUpgrade(context),
        onCreatePost: (content) => allowed ? psyProv.addPost(content) : _promptUpgrade(context),
      ),
    );
  }
}
