import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/category_model.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/core/widgets/upgrade_button_widget.dart';

import 'package:paciente_app/features/home/presentation/provider/home_provider.dart';
import 'package:paciente_app/features/home/presentation/widgets/home_header.dart';
import 'package:paciente_app/features/home/presentation/widgets/categories_grid.dart';

import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';

import 'package:paciente_app/features/medication/presentation/screen/medication_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/psicologia_screen.dart';
import 'package:paciente_app/features/nutricion/presentation/screen/nutricion_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/aptitud_screen.dart';

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
    final homeProv = context.watch<HomeProvider>();
    final patientProv = context.watch<PatientProvider>();
    final String? activePlan = patientProv.patient.activePlan;

    final PlanData planObj = AppConstants.plans.firstWhere(
      (p) => p.title == activePlan,
      orElse: () => throw StateError('Plan no encontrado: $activePlan'),
    );

    final List<CategoryModel> allowedCategories = _getAllowedCategories(activePlan);
    final bool nutricionLocked = !allowedCategories.any((c) => c.title == 'Nutrición');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(
                userName: homeProv.userName,
                userAvatar: homeProv.userAvatar,
              ),
              const SizedBox(height: 8),
              /* if (activePlan != 'Paquete Integral')
                UpgradeButton(
                  color: planObj.color,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationScreen(currentIndex: 2),
                    ),
                  ),
                ), */
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Categorías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CategoriesGrid(
                  selectedPlan: activePlan ?? '',
                  categories: allowedCategories,
                  onTapMedicamentos: () => _navigateTo(context, const MedicationScreen()),
                  onTapPsicologiaEspiritual: (needsUpgrade) => _navigateTo(
                      context,
                      PsicologiaScreen(
                        isLocked: needsUpgrade,
                        category: "Apoyo Psicológico Espiritual",
                      )),
                  onTapNutricion: (needsUpgrade) => _navigateTo(context, NutricionScreen(isLocked: needsUpgrade)),
                  onTapAptitud: (needsUpgrade) => _navigateTo(context, AptitudScreen(isLocked: needsUpgrade)),
                  onTapTelemedicina: (needsUpgrade) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationScreen(initialTab: NavigationTab.calendar),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /* 
  static final List<CategoryModel> homeCategories = [
    CategoryModel(
      title: "Medicamentos",
      iconPath: "assets/icons/pills.png",
      description: "Control y prescripción",
    ),
    CategoryModel(
      title: "Apoyo Psicológico Espiritual",
      iconPath: "assets/icons/psychology.png",
      description: "Soporte emocional y espiritual",
    ),
    CategoryModel(
      title: "Nutrición",
      iconPath: "assets/icons/nutrition.png",
      description: "Plan alimenticio y asesoría",
    ),
    CategoryModel(
      title: "Aptitud Física",
      iconPath: "assets/icons/estirado.png",
      description: "Ejercicio y rutinas adaptadas",
    ),
    CategoryModel(
      title: "Telemedicina",
      iconPath: "assets/icons/telemedicine.png",
      description: "Videoconsultas seguras y seguimiento remoto",
    ),
  ];
   */

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
        //break;
        return allCats;

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
        //filtered.add(allCats[1]);
        //break;
        return allCats;

      case "Paquete Nutrición":
        // Medicamentos + Nutrición
        //filtered.add(allCats[2]);
        //break;
        return allCats;

      case "Paquete Aptitud Física":
        // Medicamentos + Aptitud Física
        //filtered.add(allCats[3]);
        //break;
        return allCats;
    }
    return filtered;
  }
}
