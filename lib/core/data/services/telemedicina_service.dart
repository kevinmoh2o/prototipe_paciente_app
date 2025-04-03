class TelemedDoctor {
  final String name;
  final String specialty; // "Oncología Médica", "Radioterapia", "Hematología"...
  final double rating; // rating 1..5
  final String profileImage; // ruta asset
  final String bio; // descripción breve

  TelemedDoctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.profileImage,
    required this.bio,
  });
}

class TelemedicinaService {
  // Lista con las especialidades oncológicas “restantes”
  // (No Apoyo Psicológico, Nutrición, Aptitud, etc. que van en el home)
  static final List<TelemedDoctor> sampleDoctors = [
    TelemedDoctor(
      name: "Dr. José Santillán",
      specialty: "Oncología Médica",
      rating: 4.8,
      profileImage: "assets/images/doctor_male_1.png",
      bio: "Especialista en tratamientos sistémicos oncológicos con amplia experiencia.",
    ),
    TelemedDoctor(
      name: "Dra. Paola Martínez",
      specialty: "Hematología Oncológica",
      rating: 4.5,
      profileImage: "assets/images/doctor_female_1.png",
      bio: "Manejo de enfermedades hematológicas oncológicas vía teleconsulta.",
    ),
    TelemedDoctor(
      name: "Dr. Ignacio Pérez",
      specialty: "Radioterapia",
      rating: 4.2,
      profileImage: "assets/images/doctor_male_2.png",
      bio: "Procedimientos de radioterapia para distintos tipos de cáncer.",
    ),
    TelemedDoctor(
      name: "Dra. Valeria Ríos",
      specialty: "Oncología Pediátrica",
      rating: 4.9,
      profileImage: "assets/images/doctor_female_2.png",
      bio: "Especializada en tratamientos oncológicos infantiles.",
    ),
    TelemedDoctor(
      name: "Dr. Alonso Vega",
      specialty: "Oncología Ginecológica",
      rating: 4.6,
      profileImage: "assets/images/doctor_male_3.png",
      bio: "Detección y tratamiento de cáncer ginecológico a distancia.",
    ),
    TelemedDoctor(
      name: "Dra. Carmela Suárez",
      specialty: "Cirugía Oncológica",
      rating: 4.3,
      profileImage: "assets/images/doctor_female_1.png",
      bio: "Consultas pre y post quirúrgicas oncológicas.",
    ),
    TelemedDoctor(
      name: "Dr. Ricardo González",
      specialty: "Oncología Médica",
      rating: 4.7,
      profileImage: "assets/images/doctor_male_4.png",
      bio: "Experto en tratamientos innovadores en oncología médica con más de 15 años de experiencia.",
    ),
    TelemedDoctor(
      name: "Dra. Lourdes Fernández",
      specialty: "Oncología Médica",
      rating: 4.9,
      profileImage: "assets/images/doctor_female_3.png",
      bio: "Especialista en quimioterapia y terapias dirigidas para el tratamiento de cáncer avanzado.",
    ),

    // Radioterapia
    TelemedDoctor(
      name: "Dr. Luis Hernández",
      specialty: "Radioterapia",
      rating: 4.6,
      profileImage: "assets/images/doctor_male_5.png",
      bio: "Manejo de radioterapia para cánceres de diferentes tipos y etapas.",
    ),
    TelemedDoctor(
      name: "Dra. Beatriz Soto",
      specialty: "Radioterapia",
      rating: 4.4,
      profileImage: "assets/images/doctor_female_4.png",
      bio: "Radioterapeuta especializada en radioterapia paliativa y curativa.",
    ),

    // Oncología Pediátrica
    TelemedDoctor(
      name: "Dr. Eduardo Herrera",
      specialty: "Oncología Pediátrica",
      rating: 4.8,
      profileImage: "assets/images/doctor_male_6.png",
      bio: "Tratamientos oncológicos pediátricos con un enfoque integral en niños.",
    ),
    TelemedDoctor(
      name: "Dra. Mariana Gómez",
      specialty: "Oncología Pediátrica",
      rating: 5.0,
      profileImage: "assets/images/doctor_female_5.png",
      bio: "Experta en oncología pediátrica con un enfoque empático hacia los niños y sus familias.",
    ),

    // Oncología Torácica
    TelemedDoctor(
      name: "Dr. Ricardo López",
      specialty: "Oncología Torácica",
      rating: 4.5,
      profileImage: "assets/images/doctor_male_7.png",
      bio: "Especialista en cánceres de pulmón y otros tumores torácicos.",
    ),
    TelemedDoctor(
      name: "Dra. Rosa Delgado",
      specialty: "Oncología Torácica",
      rating: 4.6,
      profileImage: "assets/images/doctor_female_6.png",
      bio: "Oncóloga torácica con experiencia en tratamientos avanzados de cáncer pulmonar.",
    ),

    // Oncología Digestiva
    TelemedDoctor(
      name: "Dr. Andrés Martínez",
      specialty: "Oncología Digestiva",
      rating: 4.3,
      profileImage: "assets/images/doctor_male_8.png",
      bio: "Tratamientos avanzados en cánceres del tracto digestivo.",
    ),
    TelemedDoctor(
      name: "Dra. Isabel Pérez",
      specialty: "Oncología Digestiva",
      rating: 4.7,
      profileImage: "assets/images/doctor_female_7.png",
      bio: "Especialista en cánceres gástricos, esofágicos e intestinales.",
    ),

    // Oncohematología
    TelemedDoctor(
      name: "Dr. Rafael Ruiz",
      specialty: "Oncohematología",
      rating: 4.9,
      profileImage: "assets/images/doctor_male_9.png",
      bio: "Experto en leucemias y linfomas, con enfoque en terapias avanzadas.",
    ),
    TelemedDoctor(
      name: "Dra. Carolina Bravo",
      specialty: "Oncohematología",
      rating: 4.8,
      profileImage: "assets/images/doctor_female_8.png",
      bio: "Oncohematóloga especializada en la atención integral de enfermedades hematológicas malignas.",
    ),

    // Inmunooncología
    TelemedDoctor(
      name: "Dr. Hugo González",
      specialty: "Inmunooncología",
      rating: 4.6,
      profileImage: "assets/images/doctor_male_10.png",
      bio: "Especialista en terapias inmunológicas avanzadas para el tratamiento de cáncer.",
    ),
    TelemedDoctor(
      name: "Dra. Laura Sánchez",
      specialty: "Inmunooncología",
      rating: 4.7,
      profileImage: "assets/images/doctor_female_9.png",
      bio: "Experta en la aplicación de terapias inmunológicas para mejorar los resultados oncológicos.",
    ),
  ];
}
