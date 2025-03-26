import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel medication;

  const MedicationCard({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.read<CartProvider>();

    // Calcula si hay descuento
    final hasDiscount = medication.discountPercentage > 0;
    final discountFactor = 1 - (medication.discountPercentage / 100);
    final discountedPrice = (medication.price * discountFactor).toStringAsFixed(2);

    return Stack(
      children: [
        // CARD PRINCIPAL
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // IMAGEN
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  medication.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOMBRE
                      Text(
                        medication.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // FARMACIA
                      Text(
                        'Farmacia: ${medication.pharmacy}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),

                      // PRESENTACIONES
                      if (medication.presentation.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: medication.presentation.map((p) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  p,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      const SizedBox(height: 6),

                      // PRECIOS
                      Row(
                        children: [
                          // Precio original (tachado) si hay descuento
                          if (hasDiscount)
                            Text(
                              'S/ ${medication.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          // Espacio si hay descuento
                          if (hasDiscount) const SizedBox(width: 8),
                          // Precio final
                          Text(
                            hasDiscount ? 'S/ $discountedPrice' : 'S/ ${medication.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: hasDiscount ? Colors.green : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // BOTÓN AGREGAR
              Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: medication.isAvailable ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: medication.isAvailable
                      ? () {
                          cartProv.addToCart(medication);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Agregado: ${medication.name}')),
                          );
                        }
                      : null,
                  child: const Text(
                    'Agregar',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        // RIBBON DE DESCUENTO
        if (hasDiscount) _DiscountRibbon(discount: medication.discountPercentage),

        // OVERLAY "NO DISPONIBLE"
        if (!medication.isAvailable)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                'NO DISPONIBLE',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Ribbon que aparece en la esquina superior izquierda con el % de descuento
class _DiscountRibbon extends StatelessWidget {
  final double discount;
  const _DiscountRibbon({Key? key, required this.discount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = 'SALE\n-${discount.toStringAsFixed(0)}%';

    return Positioned(
      top: 0,
      left: 0,
      child: ClipPath(
        clipper: _RibbonClipper(),
        child: Container(
          width: 60,
          height: 60,
          color: Colors.red,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 6),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Crea un triángulo invertido (ribbon) en la esquina sup. izq.
class _RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Triángulo que cubre la esquina
    final path = Path();
    path.lineTo(0, size.height); // de top-left a bottom-left
    path.lineTo(size.width, 0); // diagonal a top-right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_RibbonClipper oldClipper) => false;
}
