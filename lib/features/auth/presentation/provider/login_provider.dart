import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/services/credential_service.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  final CredentialService _credentialService = CredentialService();

  LoginProvider() {
    // Al iniciar, puedes intentar recuperar credenciales guardadas
    _loadStoredCredentials();
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
    notifyListeners();

    // Aquí simulas un delay como si fuera una llamada a un backend
    await Future.delayed(const Duration(seconds: 2));

    // Simulación: validación exitosa
    if (_rememberMe) {
      await _credentialService.storeCredentials(
        emailController.text,
        passwordController.text,
      );
    } else {
      // Si no se desea recordar, limpiamos
      await _credentialService.clearCredentials();
    }

    _isLoading = false;
    notifyListeners();

    // Aquí podrías hacer la navegación o callback
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
