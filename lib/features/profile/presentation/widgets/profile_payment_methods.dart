import 'package:flutter/material.dart';
import 'package:paciente_app/features/profile/presentation/widgets/add_card_dialog.dart';

class ProfilePaymentMethods extends StatefulWidget {
  final Function(String) onUpdatePayment;

  /// Si deseas manejar lista de tarjetas desde fuera, podrías recibir un callback
  /// o inyectar un Provider. Aquí, por simplicidad, lo manejamos local.
  const ProfilePaymentMethods({
    Key? key,
    required this.onUpdatePayment,
  }) : super(key: key);

  @override
  State<ProfilePaymentMethods> createState() => _ProfilePaymentMethodsState();
}

class _ProfilePaymentMethodsState extends State<ProfilePaymentMethods> {
  // “Métodos rápidos”:
  final List<_PaymentOption> _options = [
    _PaymentOption("Visa", "assets/payment/visa.png"),
    _PaymentOption("Mastercard", "assets/payment/masterdcard.png"),
    _PaymentOption("Yape", "assets/payment/yape.png"),
    _PaymentOption("Plin", "assets/payment/plin.png"),
  ];
  String? _selectedMethod;

  // Lista de tarjetas guardadas localmente (en un caso real, vendrían del Provider)
  final List<CardModel> _cardList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Métodos rápidos en forma horizontal
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final opt = _options[index];
              final isSelected = (opt.name == _selectedMethod);
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMethod = opt.name);
                  widget.onUpdatePayment(opt.name);
                },
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.grey[100],
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(opt.assetPath, fit: BoxFit.contain),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _selectedMethod == null ? "Método rápido no seleccionado" : "Método seleccionado: $_selectedMethod",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),

        const SizedBox(height: 16),

        // Sección tarjetas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tarjetas Guardadas", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: _showAddCardDialog,
              icon: const Icon(Icons.add),
              label: const Text("Agregar"),
            ),
          ],
        ),
        _cardList.isEmpty
            ? const Text("No tienes tarjetas guardadas.", style: TextStyle(color: Colors.grey))
            : Column(
                children: _cardList.map((card) {
                  return _buildCardItem(card);
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildCardItem(CardModel card) {
    // Muestra un rectángulo con parte de la info de la tarjeta
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Ícono genérico o reconocimiento BIN
          const Icon(Icons.credit_card, size: 36),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("Vence: ${card.expiryDate}"),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _cardList.remove(card);
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (_) => AddCardDialog(
        onSave: (newCard) {
          setState(() => {_cardList.add(newCard)});
        },
      ),
    );
  }
}

// PaymentOption
class _PaymentOption {
  final String name;
  final String assetPath;
  _PaymentOption(this.name, this.assetPath);
}

// CardModel interno para demo
class CardModel {
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvv;

  CardModel({required this.cardNumber, required this.holderName, required this.expiryDate, required this.cvv});
}
