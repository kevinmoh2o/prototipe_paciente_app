import 'package:paciente_app/core/theme/theme_provider.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';
import 'package:paciente_app/features/auth/presentation/provider/login_provider.dart';
import 'package:paciente_app/features/auth/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/home/presentation/provider/home_provider.dart';
import 'package:paciente_app/features/medication/presentation/provider/medication_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';
import 'package:paciente_app/features/telemedicina/presentation/provider/telemedicina_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => TelemedicinaProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PsicologiaProvider()),
        ChangeNotifierProvider(create: (_) => NutricionProvider()),
        ChangeNotifierProvider(create: (_) => AptitudProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProv = context.watch<ThemeProvider>();

          return MaterialApp(
            title: 'Onco 360',
            theme: themeProv.themeData,
            debugShowCheckedModeBanner: false,

            // Aquí usamos builder para limitar el ancho,
            // PERO no metemos un Scaffold extra. Solo un Container + Center.
            builder: (context, child) {
              // child es la pantalla (LoginScreen, etc.)
              return Container(
                // color de fondo que desees para la "app entera"
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              );
            },
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
