// lib/core/widgets/plan_buttons_column.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:paciente_app/core/widgets/premium_option_button.dart';

class PlanButtonsColumn extends StatelessWidget {
  final String categoryTitle;
  final void Function(PlanData) onPlanSelected;

  const PlanButtonsColumn({
    super.key,
    required this.categoryTitle,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    final plans = PlanHelper.plansForCategory(categoryTitle);
    return Column(
      children: plans
          .map(
            (plan) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PremiumOptionButton.fromPlan(
                plan,
                onPressed: () => onPlanSelected(plan),
              ),
            ),
          )
          .toList(),
    );
  }
}
