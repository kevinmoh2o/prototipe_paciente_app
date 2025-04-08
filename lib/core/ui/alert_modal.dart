import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  /// Detalle opcional que se muestra en texto más pequeño
  /// (solo visible en modo Dialog).
  final String detail;

  /// Determina si se muestra un SnackBar (false) o un Dialog (true).
  final bool forceDialog;

  /// Ícono personalizado (Widget) a mostrar arriba del título (solo en Dialog).
  final Widget? customIcon;

  /// Imagen local opcional (asset). P.e.: 'assets/images/error.png'
  final String? imageAsset;

  /// Texto del botón principal (por defecto “OK”).
  final String? primaryButtonLabel;

  const AlertModal({
    Key? key,
    required this.color,
    required this.title,
    required this.description,
    this.detail = '',
    this.forceDialog = false,
    this.customIcon,
    this.imageAsset,
    this.primaryButtonLabel,
  }) : super(key: key);

  // ----------------------------------------------------
  // 1) MOSTRAR ALERTA (SnackBar o Dialog) SEGÚN forceDialog
  // ----------------------------------------------------
  static void showAlert(
    BuildContext context, {
    required Color color,
    required String title,
    required String description,
    String detail = '',
    bool forceDialog = false,
    int snackbarDurationInSeconds = 3,
    String? primaryButtonLabel,
    Widget? customIcon,
    String? imageAsset,
  }) {
    if (!forceDialog) {
      // Modo SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Evitar colas
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: Duration(seconds: snackbarDurationInSeconds),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                // Puedes personalizar aquí cómo concatenas
                '$title\n$description',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Modo Dialog
      showDialog(
        context: context,
        barrierDismissible: false, // No cerrar al tocar fuera
        builder: (_) => AlertModal(
          color: color,
          title: title,
          description: description,
          detail: detail,
          forceDialog: true,
          customIcon: customIcon,
          imageAsset: imageAsset,
          primaryButtonLabel: primaryButtonLabel,
        ),
      );
    }
  }

  // ----------------------------------------------------
  // 2) MOSTRAR SOLO SnackBar (método auxiliar/atajo)
  // ----------------------------------------------------
  static void showSnack(
    BuildContext context, {
    required Color color,
    required String title,
    required String description,
    String detail = '',
    int durationSeconds = 3,
  }) {
    showAlert(
      context,
      color: color,
      title: title,
      description: description,
      detail: detail,
      forceDialog: false, // Fuerza modo SnackBar
      snackbarDurationInSeconds: durationSeconds,
    );
  }

  // ----------------------------------------------------
  // CONSTRUCCIÓN DEL AlertDialog (cuando forceDialog = true)
  // ----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Color de fondo “suave” (para el Card) basado en color principal
    final Color backgroundColor = color.withOpacity(0.1);

    // Determinar la etiqueta del botón principal
    final String buttonText = primaryButtonLabel ?? 'OK';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      backgroundColor: Colors.transparent, // Para dibujar un card custom
      child: Card(
        color: backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Icono / Imagen Superior ---
              if (customIcon != null)
                customIcon!
              else if (imageAsset != null) ...[
                Image.asset(imageAsset!, width: 80, height: 80),
              ] else
                // Icono por defecto (informativo)
                Icon(Icons.info, color: color, size: 60),

              const SizedBox(height: 16),

              // --- Título ---
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // --- Descripción ---
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // --- Detalle (más pequeño, opcional) ---
              if (detail.isNotEmpty) ...[
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
              ],

              // --- Botón principal (OK u otro) ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: color,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
