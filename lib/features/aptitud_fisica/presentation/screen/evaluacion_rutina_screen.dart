// lib/features/aptitud_fisica/presentation/screen/evaluacion_rutina_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';

class EvaluacionRutinaScreen extends StatefulWidget {
  const EvaluacionRutinaScreen({Key? key}) : super(key: key);

  @override
  State<EvaluacionRutinaScreen> createState() => _EvaluacionRutinaScreenState();
}

class _EvaluacionRutinaScreenState extends State<EvaluacionRutinaScreen> {
  final _formKey = GlobalKey<FormState>();
  String _question1 = "";
  String _question2 = "";
  bool _question3YesNo = false;

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluación de Rutina"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Cuéntanos sobre tu actividad física y limitaciones.", style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "¿Cuántas veces a la semana haces ejercicio?",
                ),
                onChanged: (val) => _question1 = val,
                validator: (val) => (val == null || val.isEmpty) ? "Requerido" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "¿Tienes alguna restricción médica?",
                ),
                onChanged: (val) => _question2 = val,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text("¿Sientes fatiga al caminar distancias cortas?"),
                value: _question3YesNo,
                onChanged: (val) {
                  setState(() => _question3YesNo = val ?? false);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    aptProv.setEvaluationAnswer("q1", _question1);
                    aptProv.setEvaluationAnswer("q2", _question2);
                    aptProv.setEvaluationAnswer("q3", _question3YesNo);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Evaluación guardada")));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text("Enviar Evaluación"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
