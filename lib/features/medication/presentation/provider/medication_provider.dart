// lib/features/medication/presentation/provider/medication_provider.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';
import 'package:paciente_app/features/medication/data/services/medication_service.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _service = MedicationService();
  List<MedicationModel> allMedications = [];
  List<MedicationModel> filteredMedications = [];
  bool isLoading = false;

  MedicationProvider() {
    loadMedications();
  }

  Future<void> loadMedications() async {
    isLoading = true;
    notifyListeners();
    allMedications = await _service.fetchMedications();
    filteredMedications = allMedications;
    isLoading = false;
    notifyListeners();
  }

  void searchMedications(String query) {
    if (query.isEmpty) {
      filteredMedications = allMedications;
    } else {
      filteredMedications = allMedications
          .where((med) =>
              med.name.toLowerCase().contains(query.toLowerCase()) ||
              med.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
