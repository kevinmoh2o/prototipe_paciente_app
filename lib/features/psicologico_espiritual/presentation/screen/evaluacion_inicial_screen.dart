// lib/features/psicologico_espiritual/presentation/screen/evaluacion_inicial_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';

class EvaluacionInicialScreen extends StatefulWidget {
  const EvaluacionInicialScreen({Key? key}) : super(key: key);

  @override
  State<EvaluacionInicialScreen> createState() => _EvaluacionInicialScreenState();
}

class _EvaluacionInicialScreenState extends State<EvaluacionInicialScreen> {
  final _formKey = GlobalKey<FormState>();

  // Ejemplo de 2-3 preguntas
  String _question1Answer = "";
  String _question2Answer = "";
  bool _question3YesNo = false;

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluación Inicial"),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Completa este breve cuestionario para conocer tu estado emocional.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Pregunta 1
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "¿Cómo te sientes hoy?",
                ),
                onChanged: (val) {
                  _question1Answer = val;
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Por favor ingresa una respuesta";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pregunta 2
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "¿Qué es lo que más te preocupa?",
                ),
                onChanged: (val) {
                  _question2Answer = val;
                },
              ),
              const SizedBox(height: 16),

              // Pregunta 3: check
              CheckboxListTile(
                title: const Text("¿Te sientes ansioso/a últimamente?"),
                value: _question3YesNo,
                onChanged: (val) {
                  setState(() => _question3YesNo = val ?? false);
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Guardar en provider, simulado
                    psyProv.setEvaluationAnswer("q1", _question1Answer);
                    psyProv.setEvaluationAnswer("q2", _question2Answer);
                    psyProv.setEvaluationAnswer("q3", _question3YesNo);

                    //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("¡Evaluación enviada!")));
                    AlertModal.showAlert(
                      context,
                      color: Colors.green,
                      title: '¡Evaluación enviada!',
                      description: '',
                      detail: 'Detalle opcional',
                      forceDialog: false, // false => SnackBar
                      snackbarDurationInSeconds: 5,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                child: const Text("Enviar Evaluación"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
