import 'package:paciente_app/core/data/models/category_model.dart';
import 'package:paciente_app/core/data/models/doctor_model.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/models/schedule_model.dart';
import 'package:paciente_app/core/data/models/schedule_slot_model.dart';

class AppConstants {
  static const List<String> specialties = [
    'Oncología Médica',
    'Hematología',
    'Oncología Pediátrica',
    'Radioterapia',
    'Cirugía Oncológica',
    'Psicooncología',
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

  static const List<String> genders = ['Masculino', 'Femenino'];

  static const List<String> insuranceTypes = [
    'SIS (Seguro Integral de Salud)',
    'EsSalud',
    'EPS',
    'Seguro Privado',
    'Particular',
    'Otros',
  ];

  // Lista de instituciones médicas en Perú (centros de tratamiento)
  static const List<String> medicalInstitutionsPeru = [
    'Instituto Nacional de Enfermedades Neoplásicas (INEN)',
    'Hospital Nacional Edgardo Rebagliati Martins',
    'Hospital Nacional Guillermo Almenara Irigoyen',
    'Hospital Nacional Arzobispo Loayza',
    'Hospital Nacional Cayetano Heredia',
    'Hospital de la Solidaridad',
    'Hospital Nacional Hipólito Unanue',
    'Hospital María Auxiliadora',
    'Clínica Internacional',
    'Clínica Ricardo Palma',
    'Clínica San Pablo',
    'Clínica Anglo Americana',
    'Hospital Militar Central',
    'Hospital Central de la Policía Nacional del Perú',
    'Hospital de Emergencias Casimiro Ulloa',
    'Hospital Regional del Cusco',
    'Hospital Regional de Lambayeque',
    'Hospital Regional de Arequipa',
    'Hospital Alberto Sabogal Sologuren',
    'Clínica Delgado',
  ];

// Lista de países
  static const List<String> countries = [
    'Perú',
    'Argentina',
    'Bolivia',
    'Brasil',
    'Chile',
    'Colombia',
    'Ecuador',
    'México',
    'Paraguay',
    'Uruguay',
    'Venezuela',
    'Estados Unidos',
    'España',
    'Francia',
    'Italia',
    'Alemania',
    'Reino Unido',
    'Canadá',
    'Australia',
    'Japón',
    'China',
    'India',
  ];

// Lista de subespecialidades oncológicas
  static const List<String> subSpecialties = [
    'Oncología Médica',
    'Hematología Oncológica',
    'Oncología Pediátrica',
    'Radioterapia Oncológica',
    'Cirugía Oncológica',
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
    'Oncología de Precisión',
    'Psicooncología',
    'Terapia Celular y Genética Oncológica',
    'Oncología Traslacional',
  ];

  static const List<Map<String, String>> daySummaryData = [
    {
      'title': 'Citas Pendientes',
      'count': '3',
    },
    {
      'title': 'En Seguimiento',
      'count': '5',
    },
  ];

  static const List<String> notifications = [
    'Resultado de laboratorio disponible',
    'Mensaje de un paciente',
    'Recordatorio de cita para mañana',
    'Paciente derivado de otro especialista',
  ];

  static const List<Map<String, String>> quickActions = [
    {
      'label': 'Historial Clínico',
      'icon': 'assignment_ind',
    },
    {
      'label': 'Citas',
      'icon': 'date_range',
    },
    {
      'label': 'Recetas',
      'icon': 'receipt_long',
    },
    {
      'label': 'Facturación',
      'icon': 'paid',
    },
  ];

  static final List<ScheduleModel> sampleSchedules = [
    ScheduleModel(
      dayOfWeek: "Lunes",
      startTime: "09:00",
      endTime: "12:00",
      isActive: true,
    ),
    ScheduleModel(
      dayOfWeek: "Martes",
      startTime: "14:00",
      endTime: "18:00",
      isActive: true,
    ),
    ScheduleModel(
      dayOfWeek: "Jueves",
      startTime: "08:00",
      endTime: "11:00",
      isActive: false,
    ),
  ];

  static final Map<DateTime, List<ScheduleSlotModel>> sampleScheduleSlots = {
    // Para simplificar, creamos 2 días con franjas de ejemplo
    DateTime(2025, 3, 10): [
      ScheduleSlotModel(
        start: DateTime(2025, 3, 10, 9, 0),
        end: DateTime(2025, 3, 10, 12, 0),
        note: "Mañana para consultas generales",
      ),
      ScheduleSlotModel(
        start: DateTime(2025, 3, 10, 14, 0),
        end: DateTime(2025, 3, 10, 16, 0),
        note: "Revisiones oncológicas",
      ),
    ],
    DateTime(2025, 3, 11): [
      ScheduleSlotModel(
        start: DateTime(2025, 3, 11, 10, 0),
        end: DateTime(2025, 3, 11, 13, 0),
        isActive: false,
        note: "Reservado, pero desactivado temporalmente",
      ),
    ],
  };

  static const List<String> securityQuestions = [
    '¿Cuál es el nombre de tu primera mascota?',
    '¿Cuál es el nombre de tu mejor amigo de la infancia?',
    '¿En qué ciudad naciste?',
    '¿Cuál fue tu primera escuela?',
    '¿Cuál es el segundo nombre de tu madre?',
  ];

  static final List<CategoryModel> homeCategories = [
    CategoryModel(
      title: "Medicamentos",
      iconPath: "assets/icons/pills.png",
      description: "Control y prescripción",
    ),
    CategoryModel(
      title: "Apoyo Psicológico",
      iconPath: "assets/icons/psychology.png",
      description: "Orientación y soporte",
    ),
    CategoryModel(
      title: "Nutrición y Aptitud",
      iconPath: "assets/icons/nutrition.png",
      description: "Plan alimenticio y ejercicio",
    ),
    CategoryModel(
      title: "Telemedicina",
      iconPath: "assets/icons/telemedicine.png",
      description: "Consultas en línea",
    ),
  ];

  static final List<DoctorModel> topDoctors = [
    DoctorModel(
      name: "Dra. Olivia Valdivia",
      specialty: "Nutricionista",
      rating: 4.9,
      reviewsCount: 37,
      profileImage: "assets/images/doctor_female_1.png",
    ),
    DoctorModel(
      name: "Dr. Jonathan Rodríguez",
      specialty: "Psicólogo",
      rating: 4.8,
      reviewsCount: 29,
      profileImage: "assets/images/doctor_male_1.png",
    ),
    DoctorModel(
      name: "Dra. Melissa Suárez",
      specialty: "Oncóloga",
      rating: 4.7,
      reviewsCount: 45,
      profileImage: "assets/images/doctor_female_2.png",
    ),
  ];
}
