import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/services/credential_service.dart';
import 'package:paciente_app/core/data/services/patient_local_service.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  // Aquí inyectamos ambos servicios
  final CredentialService _credentialService = CredentialService();
  final PatientLocalService _patientLocalService = PatientLocalService();

  // Para mostrar un mensaje de error en la UI
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoginProvider() {
    _loadStoredCredentials(); // Carga credenciales "recordadas"
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = null; // Resetear error
    notifyListeners();

    // Simulamos una llamada a backend con un delay
    await Future.delayed(const Duration(seconds: 1));

    // 1. Obtenemos el patient guardado
    final PatientModel? storedPatient = await _patientLocalService.getPatient();

    // 2. Validamos
    if (storedPatient == null) {
      // No existe ningún registro previo
      _errorMessage = "No hay una cuenta registrada en este dispositivo.";
    } else {
      final enteredEmail = emailController.text.trim();
      final enteredPassword = passwordController.text.trim();

      if (enteredEmail == storedPatient.correo && enteredPassword == storedPatient.password) {
        // Credenciales válidas
        // Si se eligió "Recordar", guardamos en CredentialService
        if (_rememberMe) {
          await _credentialService.storeCredentials(enteredEmail, enteredPassword);
        } else {
          await _credentialService.clearCredentials();
        }
        // ÉXITO: aquí puedes navegar o hacer algo adicional
      } else {
        // Credenciales inválidas
        _errorMessage = "Correo o contraseña incorrectos.";
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadStoredCredentials() async {
    final creds = await _credentialService.getCredentials();
    if (creds != null) {
      emailController.text = creds['email'] ?? '';
      passwordController.text = creds['password'] ?? '';
      _rememberMe = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
