// lib/features/nutricion/presentation/screen/evaluacion_nutricional_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';

class EvaluacionNutricionalScreen extends StatefulWidget {
  const EvaluacionNutricionalScreen({Key? key}) : super(key: key);

  @override
  State<EvaluacionNutricionalScreen> createState() => _EvaluacionNutricionalScreenState();
}

class _EvaluacionNutricionalScreenState extends State<EvaluacionNutricionalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _question1 = "";
  String _question2 = "";
  bool _question3YesNo = false;

  @override
  Widget build(BuildContext context) {
    final nutriProv = context.watch<NutricionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluación Nutricional"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Responde estas preguntas para conocer tus hábitos alimenticios.", style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "¿Cuántas comidas completas haces al día?",
                ),
                onChanged: (val) => _question1 = val,
                validator: (val) => val == null || val.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "¿Incluyes frutas/verduras en tus comidas?",
                ),
                onChanged: (val) => _question2 = val,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text("¿Consumes bebidas azucaradas con frecuencia?"),
                value: _question3YesNo,
                onChanged: (val) {
                  setState(() => _question3YesNo = val ?? false);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    nutriProv.setEvalAnswer("q1", _question1);
                    nutriProv.setEvalAnswer("q2", _question2);
                    nutriProv.setEvalAnswer("q3", _question3YesNo);

                    AlertModal.showAlert(
                      context,
                      color: Colors.green,
                      title: 'Evaluación registrada',
                      description: '',
                      detail: 'Detalle opcional',
                      forceDialog: false, // false => SnackBar
                      snackbarDurationInSeconds: 5,
                    );
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
