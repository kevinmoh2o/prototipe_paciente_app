// lib/core/widgets/premium_option_button.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';

class PremiumOptionButton extends StatelessWidget {
  final String title;
  final double price;
  final Color color;
  final IconData icon;
  final List<String> benefits;
  final VoidCallback onPressed;
  final String currencySymbol;

  const PremiumOptionButton({
    super.key,
    required this.title,
    required this.price,
    required this.color,
    required this.icon,
    required this.benefits,
    required this.onPressed,
    this.currencySymbol = 'S/',
  });

  factory PremiumOptionButton.fromPlan(
    PlanData plan, {
    required VoidCallback onPressed,
    String currencySymbol = 'S/',
  }) {
    return PremiumOptionButton(
      title: plan.title,
      price: plan.price,
      color: plan.color,
      icon: plan.icon,
      benefits: plan.benefits,
      onPressed: onPressed,
      currencySymbol: currencySymbol,
    );
  }

  void _showBenefits(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Beneficios', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...benefits.map(
              (b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  const Icon(Icons.check_circle_outline),
                  const SizedBox(width: 8),
                  Expanded(child: Text(b)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            Text('${currencySymbol}${price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _showBenefits(context),
              child: const Icon(Icons.info_outline, color: Colors.white),
            ),
          ]),
        ),
      ),
    );
  }
}
