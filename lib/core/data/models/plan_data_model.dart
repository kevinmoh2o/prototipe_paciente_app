import 'package:flutter/material.dart';

class PlanData {
  final String title;
  final double price;
  final double physicianPrice;
  final double? discount; // 0.23 => 23%
  final String description;
  final List<String> benefits;
  final IconData icon;
  final Color color;

  const PlanData({
    required this.title,
    required this.price,
    required this.physicianPrice,
    this.discount,
    required this.description,
    required this.benefits,
    required this.icon,
    required this.color,
  });

  @override
  String toString() {
    return 'PlanData('
        'title: $title, '
        'price: \$${price.toStringAsFixed(2)}, '
        'physicianPrice: \$${physicianPrice.toStringAsFixed(2)}, '
        'discount: ${discount != null ? '${(discount! * 100).toStringAsFixed(0)}%' : '–'}, '
        'description: $description, '
        'benefits: ${benefits.join(', ')}, '
        'icon: $icon, '
        'color: $color'
        ')';
  }
}
