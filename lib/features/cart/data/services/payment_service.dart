// lib/features/cart/data/services/payment_service.dart

import 'package:paciente_app/features/cart/data/models/payment_method_model.dart';

class PaymentService {
  // Retorna la lista de métodos de pago disponibles
  static List<PaymentMethodModel> getPaymentMethods() {
    return [
      PaymentMethodModel(name: "Visa", assetIcon: "assets/payment/visa.png"),
      PaymentMethodModel(name: "Mastercard", assetIcon: "assets/payment/masterdcard.png"),
      PaymentMethodModel(name: "Yape", assetIcon: "assets/payment/yape.png"),
      PaymentMethodModel(name: "Plin", assetIcon: "assets/payment/plin.png"),
    ];
  }
}
