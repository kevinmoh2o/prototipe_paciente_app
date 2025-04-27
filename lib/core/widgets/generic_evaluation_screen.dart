// lib/core/widgets/generic_evaluation_screen.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:paciente_app/core/widgets/dialogs/upgrade_dialog.dart';

class GenericEvaluationScreen extends StatefulWidget {
  final String title;
  final String description;
  final String question1Label;
  final String question2Label;
  final String question3Title;
  final bool requireSubscription;
  final String subscriptionCategory;
  final String upgradeDescription;
  final String submitButtonText;
  final bool Function()? hasAccess;
  final void Function(String q1, String q2, bool q3) onSubmit;

  const GenericEvaluationScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.question1Label,
    required this.question2Label,
    required this.question3Title,
    required this.onSubmit,
    this.requireSubscription = false,
    this.subscriptionCategory = '',
    this.upgradeDescription = 'Elige el plan que mejor se adapte a ti para continuar con tu proceso:',
    this.submitButtonText = 'Enviar Evaluación',
    this.hasAccess,
  }) : super(key: key);

  @override
  _GenericEvaluationScreenState createState() => _GenericEvaluationScreenState();
}

class _GenericEvaluationScreenState extends State<GenericEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _q1 = '';
  String _q2 = '';
  bool _q3 = false;

  void _promptUpgrade() {
    DialogHelper.showUpgradeDialog(
      context: context,
      categoryTitle: widget.subscriptionCategory,
      description: widget.upgradeDescription,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                widget.description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Pregunta 1
              TextFormField(
                decoration: InputDecoration(labelText: widget.question1Label),
                onChanged: (v) => _q1 = v,
                validator: (v) => v == null || v.isEmpty ? 'Por favor ingresa una respuesta' : null,
              ),
              const SizedBox(height: 16),

              // Pregunta 2
              TextFormField(
                decoration: InputDecoration(labelText: widget.question2Label),
                onChanged: (v) => _q2 = v,
              ),
              const SizedBox(height: 16),

              // Pregunta 3
              CheckboxListTile(
                title: Text(widget.question3Title),
                value: _q3,
                onChanged: (v) => setState(() => _q3 = v ?? false),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: Text(widget.submitButtonText),
                onPressed: () {
                  if (widget.requireSubscription && !(widget.hasAccess?.call() ?? true)) {
                    _promptUpgrade();
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(_q1, _q2, _q3);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
