import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/services/telemedicina_service.dart';

class TelemedicinaProvider extends ChangeNotifier {
  // Lista de especialidades “restantes” para telemedicina
  final List<String> specialties = [
    "Todas",
    "Oncología Médica",
    "Radioterapia",
    "Oncología Pediátrica",
    "Cirugía Oncológica",
    'Oncología Ginecológica',
    'Oncología Torácica',
    'Oncología Digestiva',
    'Oncología Urológica',
    'Oncología Dermatológica',
    'Neurooncología',
    'Oncología de Cabeza y Cuello',
    'Oncología Ortopédica',
    'Oncología Integrativa',
    'Cuidados Paliativos Oncológicos',
    'Oncohematología',
    'Inmunooncología',
    'Genética Oncológica',
    'Farmacología Oncológica',
  ];

  // Filtros
  String? _selectedSpecialty; // null => “Todas”
  double _minRating = 1.0; // rating min

  // Data
  List<TelemedDoctor> _allDoctors = [];
  List<TelemedDoctor> _filteredDoctors = [];
  List<TelemedDoctor> get filteredDoctors => _filteredDoctors;

  String? get selectedSpecialty => _selectedSpecialty;
  double get minRating => _minRating;

  TelemedicinaProvider() {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    // Cargar la lista desde el service
    _allDoctors = TelemedicinaService.sampleDoctors;
    applyFilter();
  }

  void setSpecialty(String specialty) {
    _selectedSpecialty = (specialty == "Todas") ? null : specialty;
    notifyListeners();
  }

  void setMinRating(double rating) {
    _minRating = rating;
    notifyListeners();
  }

  void applyFilter() {
    _filteredDoctors = _allDoctors.where((doc) {
      final okSpecialty = (_selectedSpecialty == null || doc.specialty == _selectedSpecialty);
      final okRating = (doc.rating >= _minRating);
      return okSpecialty && okRating;
    }).toList();
    notifyListeners();
  }
}
