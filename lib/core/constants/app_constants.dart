import 'package:paciente_app/core/data/models/category_model.dart';
import 'package:paciente_app/core/data/models/doctor_model.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/core/data/models/schedule_model.dart';
import 'package:paciente_app/core/data/models/schedule_slot_model.dart';
import 'package:paciente_app/features/planes/data/models/plan_model.dart';

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
    "Otros"
    /* 'Oncología Digestiva',
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
    'Oncología Traslacional', */
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
      title: "Apoyo Psicológico Espiritual",
      iconPath: "assets/icons/psychology.png",
      description: "Soporte emocional y espiritual",
    ),
    CategoryModel(
      title: "Nutrición",
      iconPath: "assets/icons/nutrition.png",
      description: "Plan alimenticio y asesoría",
    ),
    CategoryModel(
      title: "Aptitud Física",
      iconPath: "assets/icons/estirado.png",
      description: "Ejercicio y rutinas adaptadas",
    ),
  ];

  static final List<DoctorModel> topDoctors = [
    DoctorModel(
      id: '1',
      name: "Dra. Olivia Valdivia",
      specialty: "Nutricionista",
      rating: 4.9,
      reviewsCount: 37,
      profileImage: "assets/images/doctor_female_1.png",
    ),
    DoctorModel(
      id: '2',
      name: "Dr. Jonathan Rodríguez",
      specialty: "Psicólogo",
      rating: 4.8,
      reviewsCount: 29,
      profileImage: "assets/images/doctor_male_1.png",
    ),
    DoctorModel(
      id: '3',
      name: "Dra. Melissa Suárez",
      specialty: "Oncóloga",
      rating: 4.7,
      reviewsCount: 45,
      profileImage: "assets/images/doctor_female_2.png",
    ),
  ];

  static final List<DoctorModel> calendarDoctors = [
    DoctorModel(
      id: '4',
      name: "Dra. Olivia Valdivia",
      specialty: "Psico-Oncóloga",
      rating: 4.9,
      reviewsCount: 37,
      consultationFee: 150, // Precio en soles
      profileImage: "assets/images/doctor_female_1.png",
    ),
    DoctorModel(
      id: '5',
      name: "Dr. Hiroshi Tanaka",
      specialty: "Psico-Oncólogo",
      rating: 4.8,
      reviewsCount: 25,
      consultationFee: 160, // Precio en soles
      profileImage: "assets/images/doctor_male_1.png",
    ),
    DoctorModel(
      id: '6',
      name: "Dra. Melissa Suárez",
      specialty: "Nutrióloga Oncóloga",
      rating: 4.7,
      reviewsCount: 45,
      consultationFee: 140, // Precio en soles
      profileImage: "assets/images/doctor_female_2.png",
    ),
    DoctorModel(
      id: '7',
      name: "Dr. Arturo Yupanqui",
      specialty: "Oncología Médica",
      rating: 4.8,
      reviewsCount: 30,
      consultationFee: 200, // Precio en soles
      profileImage: "assets/images/doctor_male_2.png",
    ),
    DoctorModel(
      id: '8',
      name: "Dra. Patricia Gómez",
      specialty: "Psico-Oncóloga",
      rating: 4.9,
      reviewsCount: 22,
      consultationFee: 150, // Precio en soles
      profileImage: "assets/images/doctor_female_3.png",
    ),
    /* DoctorModel(
      id: '9',
      name: "Dr. Alejandro Pinto",
      specialty: "Oncología Pediátrica",
      rating: 4.6,
      reviewsCount: 19,
      consultationFee: 220, // Precio en soles
      profileImage: "assets/images/doctor_male_3.png",
    ),
    DoctorModel(
      id: '10',
      name: "Dra. Verónica Salas",
      specialty: "Cuidados Paliativos",
      rating: 4.8,
      reviewsCount: 48,
      consultationFee: 180, // Precio en soles
      profileImage: "assets/images/doctor_female_4.png",
    ),
    DoctorModel(
      id: '11',
      name: "Dr. Emiliano Quispe",
      specialty: "Nutricionista Oncológico",
      rating: 4.7,
      reviewsCount: 34,
      consultationFee: 140, // Precio en soles
      profileImage: "assets/images/doctor_male_4.png",
    ),
    DoctorModel(
      id: '12',
      name: "Dra. Sofía Arellano",
      specialty: "Psico-Oncóloga",
      rating: 4.8,
      reviewsCount: 40,
      consultationFee: 150, // Precio en soles
      profileImage: "assets/images/doctor_female_5.png",
    ),
    DoctorModel(
      id: '13',
      name: "Dr. Samuel Torres",
      specialty: "Oncología Médica",
      rating: 4.5,
      reviewsCount: 29,
      consultationFee: 200, // Precio en soles
      profileImage: "assets/images/doctor_male_5.png",
    ),
    DoctorModel(
      id: '14',
      name: "Dra. Carmen Delgado",
      specialty: "Telemedicina Oncológica",
      rating: 4.7,
      reviewsCount: 51,
      consultationFee: 120, // Precio en soles
      profileImage: "assets/images/doctor_female_6.png",
    ),
    DoctorModel(
      id: '15',
      name: "Dr. Renato Silva",
      specialty: "Radioterapeuta Oncológico",
      rating: 4.7,
      reviewsCount: 33,
      consultationFee: 250, // Precio en soles
      profileImage: "assets/images/doctor_male_6.png",
    ), */
    DoctorModel(
      id: '16',
      name: "Dra. Gabriela Contreras",
      specialty: "Nutrición Integrativa",
      rating: 4.9,
      reviewsCount: 61,
      consultationFee: 160, // Precio en soles
      profileImage: "assets/images/doctor_female_7.png",
    ),
    DoctorModel(
      id: '17',
      name: "Dr. Fernando Huertas",
      specialty: "Psico-Oncólogo",
      rating: 4.6,
      reviewsCount: 18,
      consultationFee: 150, // Precio en soles
      profileImage: "assets/images/doctor_male_7.png",
    ),
    DoctorModel(
      id: '18',
      name: "Dra. Natalia Jiménez",
      specialty: "Oncología Ginecológica",
      rating: 4.8,
      reviewsCount: 27,
      consultationFee: 220, // Precio en soles
      profileImage: "assets/images/doctor_female_8.png",
    ),
    DoctorModel(
      id: '19',
      name: "Dr. Martín López",
      specialty: "Oncología Torácica",
      rating: 4.8,
      reviewsCount: 32,
      consultationFee: 200, // Precio en soles
      profileImage: "assets/images/doctor_male_8.png",
    ),
    DoctorModel(
      id: '20',
      name: "Dra. Paula Montiel",
      specialty: "Apoyo Psicológico Oncológico",
      rating: 4.5,
      reviewsCount: 20,
      consultationFee: 140, // Precio en soles
      profileImage: "assets/images/doctor_female_9.png",
    ),
    DoctorModel(
      id: '21',
      name: "Dr. Ricardo Contreras",
      specialty: "Nutrición y Fitness Oncológico",
      rating: 4.7,
      reviewsCount: 36,
      consultationFee: 130, // Precio en soles
      profileImage: "assets/images/doctor_male_9.png",
    ),
    DoctorModel(
      id: '22',
      name: "Dra. Loreta Ponce",
      specialty: "Oncología de Precisión",
      rating: 4.9,
      reviewsCount: 41,
      consultationFee: 250, // Precio en soles
      profileImage: "assets/images/doctor_female_10.png",
    ),
    DoctorModel(
      id: '23',
      name: "Dr. Julio Miranda",
      specialty: "Oncología Digestiva",
      rating: 4.6,
      reviewsCount: 24,
      consultationFee: 220, // Precio en soles
      profileImage: "assets/images/doctor_male_10.png",
    ),
    DoctorModel(
      id: '24',
      name: "Dr. César Ramírez",
      specialty: "Aptitud Física Oncológica",
      rating: 4.7,
      reviewsCount: 40,
      consultationFee: 130, // Precio en soles
      profileImage: "assets/images/doctor_male_1.png",
    ),
    DoctorModel(
      id: '25',
      name: "Dra. Carolina Pérez",
      specialty: "Aptitud Física Oncológica",
      rating: 4.8,
      reviewsCount: 35,
      consultationFee: 140, // Precio en soles
      profileImage: "assets/images/doctor_female_9.png",
    ),
    DoctorModel(
      id: '26',
      name: "Dr. Jorge Castillo",
      specialty: "Aptitud Física Oncológica",
      rating: 4.6,
      reviewsCount: 28,
      consultationFee: 120, // Precio en soles
      profileImage: "assets/images/doctor_male_7.png",
    ),
    DoctorModel(
      id: '27',
      name: "Dra. Laura Méndez",
      specialty: "Aptitud Física Oncológica",
      rating: 4.9,
      reviewsCount: 50,
      consultationFee: 150, // Precio en soles
      profileImage: "assets/images/doctor_female_4.png",
    ),
  ];

  static final List<PlanModel> samplePlans = [
    PlanModel(
      title: "Paquete Integral",
      price: 175.0,
      discount: 0.23, // 23%
      description: "Acceso a todos los paquetes: Medicamentos, Telemedicina, Apoyo Psicológico y Nutrición/Aptitud Física.",
      benefits: ["Consultas de telemedicina ilimitadas", "Medicamentos con descuentos", "Apoyo psicológico 24/7", "Nutrición y aptitud física"],
    ),
    PlanModel(
      title: "Paquete Telemedicina",
      price: 70.0,
      description: "Consultas de telemedicina con especialistas oncológicos.",
      discount: 0.10, // 10%
      benefits: ["Consultas médicas virtuales", "Soporte oncológico prioritario"],
    ),
    PlanModel(
      title: "Paquete Apoyo Psicológico",
      price: 50.0,
      discount: 0.23,
      description: "Acceso a consultas de apoyo psicológico y espiritual",
      benefits: ["Sesiones de psicología oncológica", "Terapia grupal virtual"],
    ),
    PlanModel(
      title: "Paquete Nutrición",
      price: 50.0,
      discount: 0.23,
      description: "Acceso a consultas de nutrición",
      benefits: [
        "Planes de alimentación oncológica",
      ],
    )
  ];

  // LiAsta de planes interna
  static final List<PlanData> plans = [
    PlanData(
      title: "Plan Básico",
      price: 0.0, // Puede ser gratuito o con un precio simbólico
      discount: 0.0,
      description: "Plan básico sin acceso a los beneficios exclusivos. El usuario puede cancelar en cualquier momento.",
      benefits: ["Acceso limitado a contenido", "Posibilidad de cancelar en cualquier momento"],
    ),
    PlanData(
      title: "Paquete Integral",
      price: 175.0,
      discount: 0.23,
      description: "Acceso a todos los paquetes: Medicamentos, Telemedicina, Apoyo Psicológico y Nutrición/Aptitud Física.",
      benefits: ["Consultas de telemedicina ilimitadas", "Medicamentos con descuentos", "Apoyo psicológico 24/7", "Nutrición y aptitud física"],
    ),
    PlanData(
      title: "Paquete Telemedicina",
      price: 70.0,
      discount: 0.10,
      description: "Consultas virtuales con especialistas oncológicos.",
      benefits: ["Consultas médicas virtuales", "Soporte oncológico prioritario"],
    ),
    PlanData(
      title: "Paquete Apoyo Psicológico",
      price: 50.0,
      discount: 0.23,
      description: "Acceso a consultas de apoyo psicológico y espiritual",
      benefits: ["Sesiones de psicología oncológica", "Terapia grupal virtual"],
    ),
    PlanData(
      title: "Paquete Nutrición",
      price: 50.0,
      discount: 0.23,
      description: "Acceso a consultas de nutrición",
      benefits: [
        "Planes de alimentación oncológica",
      ],
    ),
    PlanData(
      title: "Paquete Aptitud Física",
      price: 50.0,
      discount: 0.23,
      description: "Acceso a programas de aptitud física",
      benefits: [
        "Rutinas adaptadas",
      ],
    )
  ];
}
