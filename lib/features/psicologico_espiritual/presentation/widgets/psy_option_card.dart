import 'package:flutter/material.dart';
import 'package:paciente_app/features/psicologico_espiritual/data/model/psicologia_option_model.dart' show PsicologiaOptionModel;

class PsyOptionCard extends StatelessWidget {
  final PsicologiaOptionModel option;

  const PsyOptionCard({
    Key? key,
    required this.option,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favColor = option.isFavorite ? Colors.red : Colors.grey.shade300;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Imagen/ícono
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                color: Colors.blue.shade50,
                width: 90,
                height: 100,
                child: Image.asset(
                  option.iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para ir a la sección
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Ir",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Botón favorito
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(Icons.favorite, color: favColor),
                onPressed: () {
                  // Lógica para marcar/desmarcar favorito
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
