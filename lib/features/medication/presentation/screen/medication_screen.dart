import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/medication/presentation/provider/medication_provider.dart';
import 'package:paciente_app/features/medication/presentation/widgets/medication_card.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medProv = context.watch<MedicationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
      ),
      body: Column(
        children: [
          // Buscador
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
          // Lista
          Expanded(
            child: medProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: medProv.filteredMedications.length,
                    itemBuilder: (context, index) {
                      final med = medProv.filteredMedications[index];
                      return MedicationCard(medication: med);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
