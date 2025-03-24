import 'package:paciente_app/features/auth/presentation/provider/login_provider.dart';
import 'package:paciente_app/features/auth/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/home/presentation/provider/home_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
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
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: MaterialApp(
        title: 'Onco 360',
        theme: ThemeData(primaryColor: Color(0xFF5B6BF5)),
        debugShowCheckedModeBanner: false,

        // El builder se aplica a TODAS las pantallas
        builder: (context, child) {
          return Scaffold(
            // Fondo morado para toda la app
            //backgroundColor: const Color(0xFF4F47C2),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),

            // Centra el contenido y fija un ancho máximo
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                // child es la pantalla que se esté mostrando (LoginScreen, etc.)
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
        },

        // Primera pantalla (puedes cambiar a rutas nombradas si gustas)
        home: const LoginScreen(),
      ),
    );
  }
}
