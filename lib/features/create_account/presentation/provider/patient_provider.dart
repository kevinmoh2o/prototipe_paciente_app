import 'package:flutter/foundation.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/services/patient_local_service.dart';

class PatientProvider extends ChangeNotifier {
  final PatientLocalService _patientService = PatientLocalService();
  PatientModel? _currentPatient;

  PatientModel _patient = PatientModel();

  PatientModel? get currentPatient => _currentPatient;
  PatientModel get patient => _patient;
  int _counterIntegral = 0;

  int get counterIntegral => _counterIntegral;

  set counterIntegral(int counterIntegral) {
    _counterIntegral = counterIntegral;
    notifyListeners();
  }

  void add() {
    _patient.counterPAqueteIntegral = _patient.counterPAqueteIntegral! + 1;
    savePatient();
    notifyListeners();
  }

  void subtract() {
    _patient.counterPAqueteIntegral = _patient.counterPAqueteIntegral! - 1;
    savePatient();
    notifyListeners();
  }

  /// Carga desde Shared Preferences si existe.
  Future<void> loadPatient() async {
    final storedPatient = await _patientService.getPatient();
    _currentPatient = await _patientService.getPatient();
    if (storedPatient != null) {
      _patient = storedPatient;
      notifyListeners();
    }
  }

  /// Guarda o actualiza en Shared Preferences.
  Future<void> savePatient() async {
    await _patientService.savePatient(_patient);
  }

  /// Limpia datos en Shared Preferences.
  Future<void> clearPatient() async {
    await _patientService.clearPatient();
    _patient = PatientModel();
    notifyListeners();
  }

  /// Setters opcionales para campos específicos
  void setNombre(String value) {
    _patient.nombre = value;
    notifyListeners();
  }

  Future<void> registerPatient(PatientModel patient) async {
    await _patientService.savePatient(patient);
    _currentPatient = patient;
    notifyListeners();
  }

  void setActivePlan(String planName) async {
    await loadPatient();
    if (planName == 'Paquete Integral') {
      _patient.counterPAqueteIntegral = 2;
    } else {
      _patient.counterPAqueteIntegral = 0;
    }
    //print(planName);
    //print(_patient.toString());
    _patient.activePlan = planName;
    notifyListeners();
    savePatient();
  }
}
