import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';

class MedicationCard extends StatefulWidget {
  final MedicationModel medication;
  const MedicationCard({Key? key, required this.medication}) : super(key: key);

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final medication = widget.medication;
    final cartProv = context.read<CartProvider>();
    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan;

    // Aplica descuento solo si el plan es "Paquete Integral" y discountPercentage > 0.
    final bool hasPlanDiscount = (activePlan == "Paquete Integral") && (medication.discountPercentage > 0);
    final discountFactor = hasPlanDiscount ? (1 - (medication.discountPercentage / 100)) : 1;
    final discountedPrice = medication.price * discountFactor;

    final bool isInStock = medication.stock > 0;

    // Chequeamos si este medicamento está en el carrito
    final bool isInCart = cartProv.isInCart(medication.id);

    return Stack(
      children: [
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
          // Contenido principal
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

              // Información
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

                      const SizedBox(height: 4),

                      // STOCK
                      Text(
                        'Stock: ${medication.stock}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isInStock ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
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
                          if (hasPlanDiscount)
                            Text(
                              'S/ ${medication.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),

                          if (hasPlanDiscount) const SizedBox(width: 8),
                          Text(
                            'S/ ${discountedPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: hasPlanDiscount ? Colors.green : Colors.blue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Selector de cantidad
                      Row(
                        children: [
                          IconButton(
                            onPressed: isInStock
                                ? () {
                                    if (_quantity > 1) {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  }
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: isInStock
                                ? () {
                                    // No exceder el stock
                                    if (_quantity < medication.stock) {
                                      setState(() {
                                        _quantity++;
                                      });
                                    }
                                  }
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
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
                    backgroundColor: isInStock ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isInStock
                      ? () {
                          cartProv.addToCart(medication, _quantity);
                          AlertModal.showAlert(
                            context,
                            color: Colors.green,
                            title: 'Agregado:',
                            description: '${medication.name} x $_quantity',
                            detail: 'Detalle opcional',
                            forceDialog: false, // false => SnackBar
                            snackbarDurationInSeconds: 5,
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

        // ÍCONO DE ELIMINAR (si ya está en el carrito)
        if (isInCart)
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {
                cartProv.removeFromCart(medication.id);
                AlertModal.showAlert(
                  context,
                  color: Colors.orange,
                  title: 'Eliminado del carrito: ',
                  description: medication.name,
                  detail: 'Detalle opcional',
                  forceDialog: false, // false => SnackBar
                  snackbarDurationInSeconds: 5,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        // RIBBON DE DESCUENTO
        if (hasPlanDiscount)
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: _RibbonClipper(),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.red,
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    'SALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // OVERLAY "NO DISPONIBLE" si stock == 0
        if (!isInStock)
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

/// Clipper para el ribbon "SALE"
class _RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Triángulo
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_RibbonClipper oldClipper) => false;
}
