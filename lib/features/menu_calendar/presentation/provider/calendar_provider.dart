import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/doctor_model.dart';
import 'package:paciente_app/core/constants/app_constants.dart';

const Color kPrimaryColor = Color(0xFF5B6BF5);

enum CalendarFlowStep {
  idle, // Muestra lista de citas
  hourAndDayTime, // Paso 1: Seleccionar Mañana/Tarde/Noche + la Hora
  category, // Paso 2: Tipo de consulta
  doctor, // Paso 3: Seleccionar doctor
  confirm // Paso 4: Confirmar
}

enum DayTime { maniana, tarde, noche }

enum AppointmentCategory {
  psicologico,
  nutricion,
  telemedicina,
}

/// Representa una cita
class AppointmentModel {
  final DateTime dateTime;
  final String patientName;
  final DoctorModel doctor;
  final bool isTelemedicine;

  AppointmentModel({
    required this.dateTime,
    required this.patientName,
    required this.doctor,
    this.isTelemedicine = false,
  });
}

class CalendarProvider extends ChangeNotifier {
  // Fecha seleccionada en calendario
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // Paso del flujo
  CalendarFlowStep _currentStep = CalendarFlowStep.idle;
  CalendarFlowStep get currentStep => _currentStep;

  // Selecciones para la nueva cita
  DayTime? _selectedDayTime = DayTime.maniana;
  String? _selectedHour;
  AppointmentCategory? _selectedCategory;
  DoctorModel? _selectedDoctor;

  // Lista global de citas
  final List<AppointmentModel> _allAppointments = [
    // Ejemplo inicial
    AppointmentModel(
      dateTime: DateTime(2025, 3, 3, 8, 30),
      patientName: "Paciente Demo",
      doctor: DoctorModel(
        name: "Dr. Michael Johnson",
        specialty: "Oncólogo Médico",
        rating: 4.7,
        reviewsCount: 20,
        profileImage: "assets/images/doctor_male_1.png",
      ),
      isTelemedicine: true,
    ),
  ];
  List<AppointmentModel> get allAppointments => _allAppointments;


  // Retornamos solo las citas de la fecha seleccionada, ordenadas
  List<AppointmentModel> get appointmentsForSelectedDate {
    final daily = _allAppointments.where((a) {
      return a.dateTime.year == _selectedDate.year && a.dateTime.month == _selectedDate.month && a.dateTime.day == _selectedDate.day;
    }).toList();
    daily.sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Orden cronológico
    return daily;
  }

  // Doctores de prueba
  final List<DoctorModel> _allDoctors = AppConstants.calendarDoctors;
  List<DoctorModel> get filteredDoctors {
    if (_selectedCategory == null) return [];
    switch (_selectedCategory!) {
      case AppointmentCategory.psicologico:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("psico")).toList();
      case AppointmentCategory.nutricion:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("nutric")).toList();
      case AppointmentCategory.telemedicina:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("oncolog")).toList();
    }
  }

  // Métodos
  void selectDate(DateTime date) {
    _selectedDate = date;
    if (_currentStep != CalendarFlowStep.idle) {
      resetNewAppointment();
      _currentStep = CalendarFlowStep.idle;
    }
    notifyListeners();
  }

  void startScheduling() {
    _currentStep = CalendarFlowStep.hourAndDayTime;
    notifyListeners();
  }

  void backStep() {
    switch (_currentStep) {
      case CalendarFlowStep.idle:
      case CalendarFlowStep.hourAndDayTime:
        resetNewAppointment();
        _currentStep = CalendarFlowStep.idle;
        break;
      case CalendarFlowStep.category:
        _currentStep = CalendarFlowStep.hourAndDayTime;
        break;
      case CalendarFlowStep.doctor:
        _currentStep = CalendarFlowStep.category;
        break;
      case CalendarFlowStep.confirm:
        _currentStep = CalendarFlowStep.doctor;
        break;
    }
    notifyListeners();
  }

  void nextStep() {
    switch (_currentStep) {
      case CalendarFlowStep.hourAndDayTime:
        _currentStep = CalendarFlowStep.category;
        break;
      case CalendarFlowStep.category:
        _currentStep = CalendarFlowStep.doctor;
        break;
      case CalendarFlowStep.doctor:
        _currentStep = CalendarFlowStep.confirm;
        break;
      case CalendarFlowStep.confirm:
      case CalendarFlowStep.idle:
        // nada
        break;
    }
    notifyListeners();
  }

  // Seleccionar turno
  void selectDayTime(DayTime dt) {
    print("TEST dt");
    print(dt);
    _selectedDayTime = dt;
    // Al cambiar turno, reiniciamos hora
    _selectedHour = null;
    notifyListeners();
  }

  DayTime? get selectedDayTime => _selectedDayTime;

  // Seleccionar hora
  void selectHour(String hour) {
    _selectedHour = hour;
    notifyListeners();
  }

  String? get selectedHour => _selectedHour;

  // Seleccionar categoría
  void selectCategory(AppointmentCategory cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  AppointmentCategory? get selectedCategory => _selectedCategory;

  // Seleccionar doctor
  void selectDoctor(DoctorModel doc) {
    _selectedDoctor = doc;
    notifyListeners();
  }

  DoctorModel? get selectedDoctor => _selectedDoctor;

  // Generamos la DateTime final
  DateTime? get newAppointmentDateTime {
    if (_selectedHour == null) return null;
    final parts = _selectedHour!.split(" "); // ["8:30","AM"]
    if (parts.length != 2) return null;
    final hm = parts[0].split(":"); // ["8","30"]
    final meridiem = parts[1];
    int hour = int.tryParse(hm[0]) ?? 0;
    int minute = int.tryParse(hm[1]) ?? 0;
    if (meridiem == "PM" && hour < 12) hour += 12;
    if (meridiem == "AM" && hour == 12) hour = 0;

    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );
  }

  Future<void> confirmAppointment() async {
    if (_selectedDoctor == null || newAppointmentDateTime == null) return;
    final isTele = (_selectedCategory == AppointmentCategory.telemedicina);

    _allAppointments.add(
      AppointmentModel(
        dateTime: newAppointmentDateTime!,
        patientName: "Paciente Demo",
        doctor: _selectedDoctor!,
        isTelemedicine: isTele,
      ),
    );
    resetNewAppointment();
    _currentStep = CalendarFlowStep.idle;
    notifyListeners();
  }

  void resetNewAppointment() {
    _selectedDayTime = DayTime.maniana;
    _selectedHour = null;
    _selectedCategory = null;
    _selectedDoctor = null;
  }
}
