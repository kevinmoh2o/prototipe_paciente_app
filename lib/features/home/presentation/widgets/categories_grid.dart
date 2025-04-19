import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paciente_app/core/data/models/category_model.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedPlan;

  final VoidCallback onTapMedicamentos;
  final VoidCallback onTapPsicologiaEspiritual;
  final VoidCallback onTapNutricion;
  final VoidCallback onTapAptitud;
  final VoidCallback onTapTelemedicina;

  const CategoriesGrid({
    Key? key,
    required this.categories,
    required this.selectedPlan,
    required this.onTapMedicamentos,
    required this.onTapPsicologiaEspiritual,
    required this.onTapNutricion,
    required this.onTapAptitud,
    required this.onTapTelemedicina,
  }) : super(key: key);

  Set<String> _included() {
    switch (selectedPlan) {
      case 'Paquete Integral':
        return {
          'Medicamentos',
          'Apoyo Psicológico Espiritual',
          'Nutrición',
          'Aptitud Física',
          'Telemedicina',
        };
      case 'Paquete Telemedicina':
        return {'Medicamentos', 'Telemedicina'};
      case 'Paquete Apoyo Psicológico':
        return {'Medicamentos', 'Apoyo Psicológico Espiritual'};
      case 'Paquete Nutrición':
        return {'Medicamentos', 'Nutrición'};
      case 'Paquete Aptitud Física':
        return {'Medicamentos', 'Aptitud Física'};
      default:
        return {'Medicamentos'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final included = _included();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final needsUpgrade = !included.contains(cat.title);

        final VoidCallback callback = switch (cat.title) {
          'Medicamentos' => onTapMedicamentos,
          'Apoyo Psicológico Espiritual' => onTapPsicologiaEspiritual,
          'Nutrición' => onTapNutricion,
          'Aptitud Física' => onTapAptitud,
          'Telemedicina' => onTapTelemedicina,
          _ => () {},
        };

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: callback,
            borderRadius: BorderRadius.circular(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1FF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(cat.iconPath, width: 56, height: 56),
                        const SizedBox(height: 12),
                        Text(
                          cat.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.indigo,
                          ),
                        ),
                        if (cat.description != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            cat.description!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.indigo.shade400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (needsUpgrade)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(FontAwesomeIcons.crown, size: 15, color: Colors.white),
                            SizedBox(width: 7),
                            Text(
                              'Mejorar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
