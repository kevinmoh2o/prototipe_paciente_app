import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/category_model.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryModel> categories;

  final VoidCallback onTapMedicamentos;
  final VoidCallback onTapPsicologiaEspiritual;
  final VoidCallback onTapNutricion;
  final VoidCallback onTapAptitud;
  final VoidCallback onTapTelemedicina;

  const CategoriesGrid({
    Key? key,
    required this.categories,
    required this.onTapMedicamentos,
    required this.onTapPsicologiaEspiritual,
    required this.onTapNutricion,
    required this.onTapAptitud,
    required this.onTapTelemedicina,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // quitamos el “WARNING: expected 5 categories”
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];

        // Determina el callback según el titulo, en lugar de index
        late final VoidCallback callback;
        switch (cat.title) {
          case "Medicamentos":
            callback = onTapMedicamentos;
            break;
          case "Apoyo Psicológico Espiritual":
            callback = onTapPsicologiaEspiritual;
            break;
          case "Nutrición":
            callback = onTapNutricion;
            break;
          case "Aptitud Física":
            callback = onTapAptitud;
            break;
          case "Telemedicina":
            callback = onTapTelemedicina;
            break;
          default:
            callback = () {};
        }

        return InkWell(
          onTap: callback,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(204, 230, 227, 255),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono/imagen
                Image.asset(
                  cat.iconPath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                // Título
                Text(
                  cat.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                // Descripción opcional
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
        );
      },
    );
  }
}
