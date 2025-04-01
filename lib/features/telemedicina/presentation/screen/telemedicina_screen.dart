// telemedicina_screen.dart
import 'package:flutter/material.dart';

class TelemedicinaScreen extends StatelessWidget {
  const TelemedicinaScreen({Key? key}) : super(key: key);

  // Similar a la sección de "CalendarWizard", pero más centralizado en las consultas virtuales.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Telemedicina Oncológica")),
      body: Center(
        child: Text("Listado de especialidades oncológicas, etc."),
      ),
    );
  }
}
