// lib/features/psicologico_espiritual/presentation/widgets/psy_option_card.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/features/psicologico_espiritual/data/model/psicologia_option_model.dart';

class PsyOptionCard extends StatelessWidget {
  final PsicologiaOptionModel option;
  final VoidCallback onTapFavorite;
  final VoidCallback onTapGo;

  const PsyOptionCard({
    Key? key,
    required this.option,
    required this.onTapFavorite,
    required this.onTapGo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Imagen a la izquierda
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              color: Colors.blue.shade50,
            ),
            child: Image.asset(option.imageAsset, fit: BoxFit.contain),
          ),

          // Info principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Botones "Ir" y "Favorito"
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(option.isFavorite ? Icons.favorite : Icons.favorite_border, color: option.isFavorite ? Colors.red : Colors.grey),
                onPressed: onTapFavorite,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 8),
                child: ElevatedButton(
                  onPressed: onTapGo,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    //backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(50, 36),
                  ),
                  child: const Text("Ir"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
