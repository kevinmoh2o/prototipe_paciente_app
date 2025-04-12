import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/category_model.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/home/presentation/provider/home_provider.dart';
import 'package:paciente_app/features/home/presentation/widgets/home_header.dart';
import 'package:paciente_app/features/home/presentation/widgets/categories_grid.dart';

import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

// Importar las pantallas de cada módulo
import 'package:paciente_app/features/medication/presentation/screen/medication_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/psicologia_screen.dart';
import 'package:paciente_app/features/nutricion/presentation/screen/nutricion_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/aptitud_screen.dart';
import 'package:paciente_app/features/telemedicina/presentation/screen/telemedicina_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<HomeProvider>(context, listen: false).loadUserData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProv = Provider.of<HomeProvider>(context);

    // Tomamos el plan activo
    final patientProv = context.watch<PatientProvider>();
    final activePlan = patientProv.patient.activePlan; // p.e. "Paquete Integral"

    // Filtramos las categorías según plan
    final allowedCategories = _getAllowedCategories(activePlan);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(
                userName: homeProv.userName,
                userAvatar: homeProv.userAvatar,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Categorías",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // Usamos la lista filtrada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CategoriesGrid(
                  categories: allowedCategories,
                  onTapMedicamentos: () => _navigateTo(context, const MedicationScreen()),
                  onTapPsicologiaEspiritual: () => _navigateTo(context, const PsicologiaScreen()),
                  onTapNutricion: () => _navigateTo(context, const NutricionScreen()),
                  onTapAptitud: () => _navigateTo(context, const AptitudScreen()),
                  onTapTelemedicina: () => _navigateTo(context, const TelemedicinaScreen()),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Retorna solo las categorías a las que el plan da acceso, además de Medicamentos.
  List<CategoryModel> _getAllowedCategories(String? planTitle) {
    // Extraemos las 5 “categorías base” de tu AppConstants
    //  0: Medicamentos
    //  1: Apoyo Psicológico
    //  2: Nutrición
    //  3: Aptitud Física
    //  4: Telemedicina
    final allCats = AppConstants.homeCategories;

    // Por defecto, siempre Medicamentos
    final List<CategoryModel> filtered = [allCats[0]]; // [Medicamentos]

    switch (planTitle) {
      case null:
      case "Plan Básico":
        // Solo Medicamentos (ya lo tenemos en `filtered`).
        break;

      case "Paquete Integral":
        // Todas las categorías: [0..4]
        return allCats;

      case "Paquete Telemedicina":
        // Medicamentos + Telemedicina
        /* filtered.add(allCats[3]);
        break; */
        return allCats;
      case "Paquete Apoyo Psicológico":
        // Medicamentos + Apoyo Psicológico
        filtered.add(allCats[1]);
        break;

      case "Paquete Nutrición":
        // Medicamentos + Nutrición
        filtered.add(allCats[2]);
        break;

      case "Paquete Aptitud Física":
        // Medicamentos + Aptitud Física
        filtered.add(allCats[3]);
        break;
    }
    return filtered;
  }
}
