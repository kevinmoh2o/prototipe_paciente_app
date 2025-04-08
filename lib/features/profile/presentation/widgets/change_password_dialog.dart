import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientProv = context.watch<PatientProvider>();

    return AlertDialog(
      title: const Text("Cambiar Contraseña"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña Actual",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nueva Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmar Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            // Verificar vieja pass? (guardada en patientProv.patient.password)
            final oldStored = patientProv.patient.password ?? "";
            if (_oldPassCtrl.text != oldStored) {
              //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contraseña actual incorrecta.")));
              AlertModal.showAlert(
                context,
                color: Colors.red,
                title: 'Contraseña actual incorrecta.',
                description: '',
                detail: 'Detalle opcional',
                forceDialog: false, // false => SnackBar
                snackbarDurationInSeconds: 5,
              );
              return;
            }
            // Verificar nueva
            if (_newPassCtrl.text.isEmpty || _newPassCtrl.text != _confirmPassCtrl.text) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Las contraseñas no coinciden")));
              return;
            }
            // Guardar
            patientProv.patient.password = _newPassCtrl.text;
            patientProv.savePatient();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contraseña actualizada")));
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
