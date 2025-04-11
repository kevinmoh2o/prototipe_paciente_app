// lib/features/cart/data/models/payment_method_model.dart

class PaymentMethodModel {
  final String name;
  final String assetIcon; // ruta de ícono, p.e. "assets/payment/visa.png"

  PaymentMethodModel({required this.name, required this.assetIcon});
}
