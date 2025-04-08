import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:paciente_app/features/profile/presentation/widgets/profile_payment_methods.dart';

class AddCardDialog extends StatefulWidget {
  final Function(CardModel) onSave;
  const AddCardDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _cardNumberCtrl = TextEditingController();
  final _holderNameCtrl = TextEditingController();
  final _expiryDateCtrl = TextEditingController(); // "MM/YY"
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _holderNameCtrl.dispose();
    _expiryDateCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Agregar Tarjeta"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_cardNumberCtrl, "Número de Tarjeta", TextInputType.number),
            const SizedBox(height: 12),
            _buildTextField(_holderNameCtrl, "Titular (Nombre Completo)"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_expiryDateCtrl, "Vencimiento (MM/AA)", TextInputType.datetime),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(_cvvCtrl, "CVV", TextInputType.number, true),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
            onPressed: () {
              if (_cardNumberCtrl.text.isEmpty || _holderNameCtrl.text.isEmpty) {
                AlertModal.showAlert(
                  context,
                  color: Colors.red,
                  title: 'Completa al menos número y titular ',
                  description: '',
                  detail: 'Detalle opcional',
                  forceDialog: false, // false => SnackBar
                  snackbarDurationInSeconds: 5,
                );
                return;
              }
              final newCard =
                  CardModel(cardNumber: _cardNumberCtrl.text, holderName: _holderNameCtrl.text, expiryDate: _expiryDateCtrl.text, cvv: _cvvCtrl.text);
              widget.onSave(newCard);
              Navigator.pop(context);
            },
            child: const Text("Guardar"))
      ],
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, [TextInputType? ktype, bool obscure = false]) {
    return TextField(
      controller: ctrl,
      keyboardType: ktype,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
