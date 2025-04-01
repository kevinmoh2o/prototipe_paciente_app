import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/category_model.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryModel> categories;

  // Cinco callbacks
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
    // Chequea que tengamos 5 categorías en la lista, si no, ajusta la lógica
    if (categories.length != 5) {
      // Podrías lanzar un assert o algo para avisar
      debugPrint('WARNING: Se esperaban 5 categorías, recibimos ${categories.length}.');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
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

          // Determina el callback según el índice o el título
          late final VoidCallback callback;
          switch (index) {
            case 0:
              callback = onTapMedicamentos;
              break;
            case 1:
              callback = onTapPsicologiaEspiritual;
              break;
            case 2:
              callback = onTapNutricion;
              break;
            case 3:
              callback = onTapAptitud;
              break;
            case 4:
              callback = onTapTelemedicina;
              break;
            default:
              callback = () {};
              break;
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
      ),
    );
  }
}
