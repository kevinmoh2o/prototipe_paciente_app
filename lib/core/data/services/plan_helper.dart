// lib/core/services/plan_helper.dart
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';

class PlanHelper {
  static bool userHasAccess(String? userPlan, String category) {
    if (userPlan == null) return false;
    if (userPlan == 'Paquete Integral') return true;
    switch (category) {
      case 'Apoyo Psicológico Espiritual':
        return userPlan == 'Paquete Apoyo Psicológico';
      case 'Nutrición':
        return userPlan == 'Paquete Nutrición';
      case 'Aptitud Física':
        return userPlan == 'Paquete Aptitud Física';
      case 'Telemedicina':
        return userPlan == 'Paquete Telemedicina';
      default:
        return false;
    }
  }

  static List<PlanData> plansForCategory(String category) {
    switch (category) {
      case 'Apoyo Psicológico Espiritual':
        return AppConstants.plans.where((p) => p.title == 'Paquete Apoyo Psicológico' || p.title == 'Paquete Integral').toList();
      case 'Nutrición':
        return AppConstants.plans.where((p) => p.title == 'Paquete Nutrición' || p.title == 'Paquete Integral').toList();
      case 'Aptitud Física':
        return AppConstants.plans.where((p) => p.title == 'Paquete Aptitud Física' || p.title == 'Paquete Integral').toList();
      case 'Telemedicina':
        return AppConstants.plans.where((p) => p.title == 'Paquete Telemedicina' || p.title == 'Paquete Integral').toList();
      default:
        return [];
    }
  }
}
