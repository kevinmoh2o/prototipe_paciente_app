// lib/core/widgets/dialogs/upgrade_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/core/widgets/plan_buttons_column.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';

/// Servicio de diálogos reutilizables
class DialogHelper {
  DialogHelper._(); // evita instancias

  /// Muestra el diálogo para escoger un plan de la categoría `categoryTitle`.
  ///
  /// *Si `onPlanSelected` es **null*** se aplica la lógica por defecto:
  /// - Añadir el plan al carrito (si aún no está).
  /// - Cerrar el diálogo.
  /// - Navegar a la pestaña **Carrito** en `MainNavigationScreen`.
  static Future<void> showUpgradeDialog({
    required BuildContext context,
    required String categoryTitle,
    String description = 'Elige el plan que mejor se adapte a ti para continuar con tu proceso:',
    bool barrierDismissible = true,
    Function(PlanData)? onPlanSelected,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        void _defaultAction(PlanData plan) {
          final cartProv = ctx.read<CartProvider>();
          if (!cartProv.isPlanInCart(plan.title)) {
            cartProv.addPlan(plan);
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text('${plan.title} añadido al carrito')),
            );
          }
          Navigator.of(ctx).pop(); // cierra el diálogo

          // ► envía al usuario al carrito
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(
                initialTab: NavigationTab.cart, // ← cambia a tu constructor si usas otro
              ),
            ),
          );
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER ----------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(categoryTitle, style: Theme.of(ctx).textTheme.headlineSmall),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: const Icon(Icons.close, size: 24),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // CONTENT ---------------------------------------------------
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(description, style: Theme.of(ctx).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        PlanButtonsColumn(
                          categoryTitle: categoryTitle,
                          onPlanSelected: (plan) => (onPlanSelected ?? _defaultAction)(plan),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                // FOOTER ----------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
