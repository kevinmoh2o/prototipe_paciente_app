import 'package:flutter/material.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/doctor_model.dart';
import 'package:uuid/uuid.dart';

enum CalendarFlowStep {
  idle,
  hourAndDayTime,
  category,
  doctor,
  confirm,
}

enum DayTime { maniana, tarde, noche }

enum AppointmentCategory {
  psicologico,
  nutricion,
  telemedicina,
  aptitudFisica,
  // Podrías agregar aptitud_fisica aquí si lo deseas
}

class AppointmentModel {
  final String id;
  final DateTime dateTime;
  final String patientName;
  final DoctorModel doctor;
  final bool isTelemedicine;
  bool isPaid; // indica si ya fue pagada
  final double fee; // costo de la consulta

  AppointmentModel({
    required this.dateTime,
    required this.patientName,
    required this.doctor,
    this.isTelemedicine = false,
    this.isPaid = false,
    required this.fee,
    String? id,
  }) : id = id ?? const Uuid().v4();
}

class CalendarProvider extends ChangeNotifier {
  // ───────────────────────── ESTADO DEL WIZARD ─────────────────────────
  DateTime _selectedDate = DateTime.now();
  CalendarFlowStep _currentStep = CalendarFlowStep.idle;
  DayTime? _selectedDayTime = DayTime.maniana;
  String? _selectedHour;
  AppointmentCategory? _selectedCategory;
  DoctorModel? _selectedDoctor;

  // Para poder saltar pasos
  bool _skipCategoryStep = false;
  bool _skipDoctorStep = false;

  // ───────────────────────── CITAS REGISTRADAS ─────────────────────────
  final List<AppointmentModel> _allAppointments = [];
  final List<DoctorModel> _allDoctors = AppConstants.calendarDoctors;

  // ───────────────────────── GETTERS ─────────────────────────
  DateTime get selectedDate => _selectedDate;
  CalendarFlowStep get currentStep => _currentStep;
  DayTime? get selectedDayTime => _selectedDayTime;
  String? get selectedHour => _selectedHour;
  AppointmentCategory? get selectedCategory => _selectedCategory;
  DoctorModel? get selectedDoctor => _selectedDoctor;
  List<AppointmentModel> get allAppointments => _allAppointments;

  // Filtra citas del día
  List<AppointmentModel> get appointmentsForSelectedDate {
    final daily = _allAppointments.where((a) {
      return a.dateTime.year == _selectedDate.year && a.dateTime.month == _selectedDate.month && a.dateTime.day == _selectedDate.day;
    }).toList();
    daily.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return daily;
  }

  // Filtra doctores según la categoría
  List<DoctorModel> get filteredDoctors {
    if (_selectedCategory == null) return [];
    switch (_selectedCategory!) {
      case AppointmentCategory.psicologico:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("psico")).toList();
      case AppointmentCategory.nutricion:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("nutric")).toList();
      case AppointmentCategory.telemedicina:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("oncol")).toList();
      case AppointmentCategory.aptitudFisica:
        return _allDoctors.where((doc) => doc.specialty.toLowerCase().contains("ptitud")).toList();
    }
  }

  // ───────────────────────── MÉTODOS ─────────────────────────
  void selectDate(DateTime date) {
    _selectedDate = date;
    // Si estábamos en wizard y se cambió la fecha, reseteamos
    if (_currentStep != CalendarFlowStep.idle) {
      resetNewAppointment();
      _currentStep = CalendarFlowStep.idle;
    }
    notifyListeners();
  }

  /// Inicia el wizard.
  /// forcedCategory => para que no pida la categoría.
  /// forcedDoctor => para que no pida el doctor.
  /// skipCategoryStep => si true, se salta la pantalla “Tipo de consulta”.
  /// skipDoctorStep => si true, se salta la pantalla “Seleccionar Doctor”.
  void startScheduling({
    AppointmentCategory? forcedCategory,
    DoctorModel? forcedDoctor,
    bool skipCategoryStep = false,
    bool skipDoctorStep = false,
  }) {
    _skipCategoryStep = skipCategoryStep;
    _skipDoctorStep = skipDoctorStep;

    if (forcedCategory != null) {
      _selectedCategory = forcedCategory;
    }
    if (forcedDoctor != null) {
      _selectedDoctor = forcedDoctor;
    }

    // Empezamos en hourAndDayTime
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
        if (_skipCategoryStep) {
          _currentStep = CalendarFlowStep.hourAndDayTime;
        } else {
          _currentStep = CalendarFlowStep.category;
        }
        break;
      case CalendarFlowStep.confirm:
        if (_skipDoctorStep) {
          _currentStep = _skipCategoryStep ? CalendarFlowStep.hourAndDayTime : CalendarFlowStep.category;
        } else {
          _currentStep = CalendarFlowStep.doctor;
        }
        break;
    }
    notifyListeners();
  }

  void nextStep() {
    switch (_currentStep) {
      case CalendarFlowStep.hourAndDayTime:
        if (_skipCategoryStep) {
          if (_skipDoctorStep) {
            _currentStep = CalendarFlowStep.confirm;
          } else {
            _currentStep = CalendarFlowStep.doctor;
          }
        } else {
          _currentStep = CalendarFlowStep.category;
        }
        break;
      case CalendarFlowStep.category:
        if (_skipDoctorStep) {
          _currentStep = CalendarFlowStep.confirm;
        } else {
          _currentStep = CalendarFlowStep.doctor;
        }
        break;
      case CalendarFlowStep.doctor:
        _currentStep = CalendarFlowStep.confirm;
        break;
      case CalendarFlowStep.idle:
      case CalendarFlowStep.confirm:
        break;
    }
    notifyListeners();
  }

  // Selecciones
  void selectDayTime(DayTime dt) {
    _selectedDayTime = dt;
    _selectedHour = null;
    notifyListeners();
  }

  void selectHour(String hour) {
    _selectedHour = hour;
    notifyListeners();
  }

  void selectCategory(AppointmentCategory cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void selectDoctor(DoctorModel doc) {
    _selectedDoctor = doc;
    notifyListeners();
  }

  DateTime? get newAppointmentDateTime {
    if (_selectedHour == null) return null;
    final parts = _selectedHour!.split(" ");
    if (parts.length != 2) return null;
    final hm = parts[0].split(":");
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

  // Confirmar la cita final
  AppointmentModel? confirmAppointment() {
    if (_selectedDoctor == null || newAppointmentDateTime == null) {
      return null;
    }

    final newAppt = AppointmentModel(
      dateTime: newAppointmentDateTime!,
      patientName: "Paciente Demo",
      doctor: _selectedDoctor!,
      isTelemedicine: (_selectedCategory == AppointmentCategory.telemedicina),
      isPaid: false,
      fee: _selectedDoctor!.consultationFee,
    );
    _allAppointments.add(newAppt);
    notifyListeners();

    resetNewAppointment();
    _currentStep = CalendarFlowStep.idle;
    return newAppt;
  }

  // Marcar cita como pagada
  void markAppointmentAsPaid(String appointmentId) {
    final idx = _allAppointments.indexWhere((a) => a.id == appointmentId);
    if (idx != -1) {
      _allAppointments[idx].isPaid = true;
      notifyListeners();
    }
  }

  void resetNewAppointment() {
    _selectedDayTime = DayTime.maniana;
    _selectedHour = null;
    _selectedCategory = null;
    _selectedDoctor = null;
    _skipCategoryStep = false;
    _skipDoctorStep = false;
  }
}
