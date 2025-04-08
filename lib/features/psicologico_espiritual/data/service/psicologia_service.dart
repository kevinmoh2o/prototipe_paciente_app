// lib/features/psicologico_espiritual/data/service/psicologia_service.dart

import 'package:paciente_app/features/psicologico_espiritual/data/model/psicologia_option_model.dart';

class PsicologiaService {
  static List<PsicologiaOptionModel> getInitialOptions() {
    return [
      PsicologiaOptionModel(
        id: "1",
        title: "Evaluación Inicial",
        description: "Evaluación en línea con un psicólogo.",
        imageAsset: "assets/submodules/psy_eval.png",
      ),
      PsicologiaOptionModel(
        id: "2",
        title: "Consulta Psicológica",
        description: "Consulta en línea con psicólogo.",
        imageAsset: "assets/submodules/psychology.png",
        isFavorite: true,
      ),
      PsicologiaOptionModel(
        id: "3",
        title: "Apoyo Espiritual",
        description: "Entrevista con un consejero espiritual.",
        imageAsset: "assets/submodules/spiritual_support.png",
      ),
      PsicologiaOptionModel(
        id: "4",
        title: "Grupos de Apoyo",
        description: "Participa en grupos de apoyo psicológico/espiritual.",
        imageAsset: "assets/submodules/group_support.png",
      ),
    ];
  }
}
