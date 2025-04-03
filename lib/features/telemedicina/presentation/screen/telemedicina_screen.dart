import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/telemedicina/presentation/provider/telemedicina_provider.dart';
import 'package:paciente_app/features/telemedicina/presentation/widgets/telemedicina_doctors_list.dart';

class TelemedicinaScreen extends StatefulWidget {
  const TelemedicinaScreen({Key? key}) : super(key: key);

  @override
  State<TelemedicinaScreen> createState() => _TelemedicinaScreenState();
}

class _TelemedicinaScreenState extends State<TelemedicinaScreen> {
  @override
  Widget build(BuildContext context) {
    final telemedProv = context.watch<TelemedicinaProvider>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        //automaticallyImplyLeading: false, // sin flecha
        title: const Text("Telemedicina", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5B6BF5),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilters(context, telemedProv),
            const SizedBox(height: 16),
            TelemedicinaDoctorsList(doctors: telemedProv.filteredDoctors),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, TelemedicinaProvider prov) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 1. Selector especialidad
          Row(
            children: [
              const Text("Especialidad:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: prov.selectedSpecialty ?? "Todas",
                  items: prov.specialties.map((sp) {
                    return DropdownMenuItem(
                      value: sp,
                      child: Text(sp),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      prov.setSpecialty(val);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Slider rating
          Row(
            children: [
              const Text("Mín. Rating:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  min: 1.0,
                  max: 5.0,
                  divisions: 4,
                  label: "${prov.minRating.toStringAsFixed(1)}★",
                  value: prov.minRating,
                  onChanged: (val) {
                    prov.setMinRating(val);
                  },
                ),
              ),
              Text("${prov.minRating.toStringAsFixed(1)}★"),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Botón "Aplicar Filtro"
          ElevatedButton(
            onPressed: () {
              prov.applyFilter();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF324BB8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Aplicar Filtro"),
          )
        ],
      ),
    );
  }
}
