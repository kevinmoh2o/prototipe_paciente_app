import 'package:flutter/material.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class EditInfoDialog extends StatefulWidget {
  final PatientProvider patientProvider;
  const EditInfoDialog({Key? key, required this.patientProvider}) : super(key: key);

  @override
  State<EditInfoDialog> createState() => _EditInfoDialogState();
}

class _EditInfoDialogState extends State<EditInfoDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.patientProvider.patient;
    final fullName = _joinFullName(p.nombre, p.apellidoPaterno, p.apellidoMaterno);
    _nameCtrl = TextEditingController(text: fullName);
    _phoneCtrl = TextEditingController(text: p.telefono ?? "");
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Información"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre Completo"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: "Teléfono"),
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
            // parse the name in parts? o guardarlo como un solo campo "nombreCompleto"?
            // Por simplicidad, lo guardamos en "nombre" y vaciamos los apellidos
            widget.patientProvider.patient.nombre = _nameCtrl.text;
            widget.patientProvider.patient.telefono = _phoneCtrl.text;
            widget.patientProvider.savePatient(); // persistir
            Navigator.pop(context);
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  String _joinFullName(String? nombre, String? apePat, String? apeMat) {
    final parts = [nombre, apePat, apeMat].where((e) => e != null && e.isNotEmpty).toList();
    return parts.join(" ");
  }
}
