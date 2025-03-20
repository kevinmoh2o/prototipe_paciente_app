import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';

class PatientLocalService {
  static const String _patientKey = 'patient_data';

  /// Guarda o actualiza un paciente en Shared Preferences (como JSON).
  Future<void> savePatient(PatientModel patient) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(patient.toMap());
    await prefs.setString(_patientKey, jsonData);
  }

  /// Obtiene el paciente guardado (si existe).
  Future<PatientModel?> getPatient() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_patientKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> data = jsonDecode(jsonString);
    return PatientModel.fromMap(data);
  }

  /// Elimina el paciente.
  Future<void> clearPatient() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_patientKey);
  }
}
