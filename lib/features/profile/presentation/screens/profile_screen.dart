import 'package:flutter/material.dart';
import 'package:paciente_app/features/auth/presentation/screen/login_screen.dart';
import 'package:paciente_app/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/profile/presentation/widgets/profile_payment_methods.dart';
import 'package:paciente_app/features/profile/presentation/widgets/edit_info_dialog.dart';
import 'package:paciente_app/features/profile/presentation/widgets/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifWhatsApp = true; // EJEMPLO: guarda estas banderas en el model, si quieres
  bool _notifSMS = true;

  @override
  void initState() {
    super.initState();
    // Aseguramos que el PatientProvider haya cargado la data
    Future.delayed(Duration.zero, () {
      context.read<PatientProvider>().loadPatient();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProv = context.watch<PatientProvider>();
    final patient = patientProv.patient; // PatientModel

    // Nombre completo
    final String fullName = [patient.nombre, patient.apellidoPaterno, patient.apellidoMaterno].where((s) => s != null && s.isNotEmpty).join(" ");

    // Ejemplo de fecha de unión
    final DateTime joinedDate = DateTime(2024, 6, 10); // Hardcode
    final joinedString = "Se unió en ${_formatDate(joinedDate)}";

    return Scaffold(
      /*  appBar: AppBar(
        automaticallyImplyLeading: false, // no flecha
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Perfil",
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ), */
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // 1) Encabezado avatar + nombre
              ProfileAvatar(
                initials: _getInitials(fullName),
                // o si tienes imagen real, pasa la url
              ),
              const SizedBox(height: 8),
              Text(
                fullName.isEmpty ? "Nombre Desconocido" : fullName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                joinedString,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // 2) Sección "General"
              _buildSectionCard(
                title: "General",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowInfo("Nombre", fullName.isEmpty ? "Sin definir" : fullName),
                    _buildRowInfo("Correo", patient.correo ?? "Sin correo"),
                    _buildRowInfo("Teléfono", patient.telefono ?? "No registrado"),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          _showEditInfoDialog(context, patientProv);
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Editar"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3) Notificaciones
              _buildSectionCard(
                title: "Notificaciones",
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Whatsapp"),
                      value: _notifWhatsApp,
                      onChanged: (val) {
                        setState(() => _notifWhatsApp = val);
                        // Podrías guardar en patient.model
                      },
                    ),
                    SwitchListTile(
                      title: const Text("Mensaje de Texto"),
                      value: _notifSMS,
                      onChanged: (val) {
                        setState(() => _notifSMS = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4) Métodos de pago
              _buildSectionCard(
                title: "Métodos de Pago",
                child: ProfilePaymentMethods(
                  onUpdatePayment: (selectedPayment) {
                    // Podrías guardarlo en patient.model
                    // patientProv.patient.paymentMethod = selectedPayment;
                    // patientProv.savePatient();
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 5) Preferencias - cambiar contraseña, etc.
              _buildSectionCard(
                title: "Preferencias",
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text("Cambiar Contraseña"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const ChangePasswordDialog(),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.payments),
                      title: const Text("Otro Ajuste"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // ...
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 6) Botón Cerrar Sesión
              ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context, patientProv);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Cerrar Sesión", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          child,
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditInfoDialog(BuildContext context, PatientProvider prov) {
    showDialog(
      context: context,
      builder: (_) => EditInfoDialog(patientProvider: prov),
    );
  }

  void _showLogoutDialog(BuildContext context, PatientProvider prov) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Cerrar Sesión"),
              content: const Text("¿Estás seguro de querer cerrar sesión?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    //prov.clearPatient();
                    // Podrías ir al login screen
                    //Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
                ),
              ],
            ));
  }

  String _formatDate(DateTime dt) {
    return "${dt.day} ${_monthName(dt.month)} ${dt.year}";
  }

  String _monthName(int m) {
    const meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    return meses[m - 1];
  }

  String _getInitials(String fullname) {
    if (fullname.trim().isEmpty) return "??";
    final words = fullname.split(" ");
    String initials = "";
    for (var element in words) {
      if (element.isNotEmpty) {
        initials += element[0].toUpperCase();
      }
      if (initials.length == 2) break;
    }
    return initials;
  }
}
