import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa tus propios files:
import 'package:paciente_app/features/medication/presentation/provider/medication_provider.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';
import 'package:paciente_app/features/medication/presentation/widgets/medication_card.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Observa el provider de medicamentos
    final medProv = context.watch<MedicationProvider>();
    // Observa también el provider del carrito
    final cartProv = context.watch<CartProvider>();

    // Cantidad de productos en el carrito (puede ser totalItems o items.length)
    final cartCount = cartProv.totalItems; // ajusta a tu lógica

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
        actions: [
          // Ícono Carrito con contador
          IconButton(
            onPressed: () {
              // Navega a la pantalla del carrito en tu MainNavigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainNavigationScreen(currentIndex: 4),
                ),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none, // para permitir superposición
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Cuadro de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => medProv.searchMedications(val),
              decoration: const InputDecoration(
                hintText: 'Buscar Medicamento...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Lista de medicamentos
          Expanded(
            child: medProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: medProv.filteredMedications.length,
                    itemBuilder: (context, index) {
                      MedicationModel med = medProv.filteredMedications[index];
                      return MedicationCard(medication: med);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
