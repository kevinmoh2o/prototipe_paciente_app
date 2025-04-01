import 'package:paciente_app/features/psicologico_espiritual/data/model/psicologia_option_model.dart';

class PsicologiaService {
  // Datos de ejemplo
  static final List<PsicologiaOptionModel> options = [
    PsicologiaOptionModel(
      title: "Evaluación Inicial",
      description: "Evaluación en línea con un psicólogo.",
      iconPath: "assets/submodules/psy_eval.png",
    ),
    PsicologiaOptionModel(
      title: "Consulta Psicológica",
      description: "Consulta en línea con psicólogo.",
      iconPath: "assets/submodules/psychology.png",
      isFavorite: true,
    ),
    PsicologiaOptionModel(
      title: "Apoyo Espiritual",
      description: "Entrevista con un consejero espiritual.",
      iconPath: "assets/submodules/spiritual_support.png",
    ),
    PsicologiaOptionModel(
      title: "Grupos de Apoyo",
      description: "Participa en grupos de apoyo psicológico/espiritual.",
      iconPath: "assets/submodules/group_support.png",
    ),
  ];
}
