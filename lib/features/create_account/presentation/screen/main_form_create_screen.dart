import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/create_account/presentation/screen/success_registration_screen.dart';
import 'package:paciente_app/features/create_account/presentation/widgets/searchable_dropdown_field.dart';

class MainFormCreateScreen extends StatefulWidget {
  const MainFormCreateScreen({Key? key}) : super(key: key);

  @override
  _MainFormCreateScreenState createState() => _MainFormCreateScreenState();
}

class _MainFormCreateScreenState extends State<MainFormCreateScreen> {
  int _currentStep = 0;

  /// Claves de formulario para cada Step.
  final List<GlobalKey<FormState>> _formKeys = List.generate(5, (_) => GlobalKey<FormState>());

  // STEP 1: Información Básica
  final _nombreCtrl = TextEditingController();
  final _apellidoPaternoCtrl = TextEditingController();
  final _apellidoMaternoCtrl = TextEditingController();
  final _generoCtrl = TextEditingController();
  final _fechaNacCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _confirmCorreoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  // STEP 2: Información Médica
  final _diagnosticoCtrl = TextEditingController();
  final _gradoCtrl = TextEditingController();
  final _restriccionesCtrl = TextEditingController();
  final _otrasEnfermedadesCtrl = TextEditingController();
  final _tallaCtrl = TextEditingController();
  final _pesoCtrl = TextEditingController();

  // STEP 3: Seguro y Centro
  final _tipoSeguroCtrl = TextEditingController();
  final _centroTratamientoCtrl = TextEditingController();

  // STEP 4: Datos Familiar
  final _nombreFamiliarCtrl = TextEditingController();
  final _relacionFamiliarCtrl = TextEditingController();
  final _numeroEmergenciaCtrl = TextEditingController();

  // STEP 5: Confirmación Final
  bool _aceptoTerminos = false;

  @override
  void dispose() {
    // Liberar controladores
    _nombreCtrl.dispose();
    _apellidoPaternoCtrl.dispose();
    _apellidoMaternoCtrl.dispose();
    _generoCtrl.dispose();
    _fechaNacCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _confirmCorreoCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();

    _diagnosticoCtrl.dispose();
    _gradoCtrl.dispose();
    _restriccionesCtrl.dispose();
    _otrasEnfermedadesCtrl.dispose();
    _tallaCtrl.dispose();
    _pesoCtrl.dispose();

    _tipoSeguroCtrl.dispose();
    _centroTratamientoCtrl.dispose();

    _nombreFamiliarCtrl.dispose();
    _relacionFamiliarCtrl.dispose();
    _numeroEmergenciaCtrl.dispose();

    super.dispose();
  }

  void _continue() {
    final isValid = _formKeys[_currentStep].currentState?.validate() ?? false;
    if (!isValid) return;

    if (_currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      // Guardar datos y navegar a Success
      _savePatientData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessRegistrationScreen()),
      );
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Future<void> _selectFechaNacimiento() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaNacCtrl.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  void _savePatientData() {
    final provider = context.read<PatientProvider>();

    // Convertir fecha string -> DateTime
    DateTime? fechaNac;
    if (_fechaNacCtrl.text.isNotEmpty) {
      final parts = _fechaNacCtrl.text.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          fechaNac = DateTime(year, month, day);
        }
      }
    }

    provider.patient.nombre = _nombreCtrl.text;
    provider.patient.apellidoPaterno = _apellidoPaternoCtrl.text;
    provider.patient.apellidoMaterno = _apellidoMaternoCtrl.text;
    provider.patient.genero = _generoCtrl.text;
    provider.patient.fechaNacimiento = fechaNac;
    provider.patient.telefono = _telefonoCtrl.text;
    provider.patient.correo = _correoCtrl.text;
    provider.patient.password = _passwordCtrl.text;

    provider.patient.diagnostico = _diagnosticoCtrl.text;
    provider.patient.grado = _gradoCtrl.text;
    provider.patient.restriccionesAlimentacion = _restriccionesCtrl.text;
    provider.patient.otrasEnfermedades = _otrasEnfermedadesCtrl.text;
    provider.patient.talla = double.tryParse(_tallaCtrl.text);
    provider.patient.peso = double.tryParse(_pesoCtrl.text);

    provider.patient.tipoSeguro = _tipoSeguroCtrl.text;
    provider.patient.centroTratamiento = _centroTratamientoCtrl.text;

    provider.patient.nombreFamiliar = _nombreFamiliarCtrl.text;
    provider.patient.relacionFamiliar = _relacionFamiliarCtrl.text;
    provider.patient.numeroEmergencia = _numeroEmergenciaCtrl.text;

    provider.patient.aceptoTerminos = _aceptoTerminos;

    // Guardamos en SharedPreferences
    provider.savePatient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Paciente"),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          type: StepperType.vertical,
          physics: const ClampingScrollPhysics(),
          currentStep: _currentStep,
          onStepContinue: _continue,
          onStepCancel: _cancel,
          controlsBuilder: (context, details) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep != 0)
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Anterior"),
                    ),
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      _currentStep == 4 ? "Finalizar Registro ✅" : "Siguiente →",
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text("Información Básica"),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[0],
                child: _buildStep1BasicInfo(),
              ),
            ),
            Step(
              title: const Text("Información Médica"),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[1],
                child: _buildStep2MedicalInfo(),
              ),
            ),
            Step(
              title: const Text("Seguro y Centro"),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[2],
                child: _buildStep3InsuranceInfo(),
              ),
            ),
            Step(
              title: const Text("Datos de Familiar"),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[3],
                child: _buildStep4FamilyInfo(),
              ),
            ),
            Step(
              title: const Text("Confirmación"),
              isActive: _currentStep >= 4,
              state: _currentStep > 4 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[4],
                child: _buildStep5FinalConfirm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 1: INFORMACIÓN BÁSICA
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Por favor, completa los datos personales básicos."),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nombreCtrl,
          decoration: _buildDecoration("Nombre"),
          validator: (value) => value == null || value.isEmpty ? "Ingresa tu nombre" : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _apellidoPaternoCtrl,
          decoration: _buildDecoration("Apellido Paterno"),
          validator: (value) => value == null || value.isEmpty ? "Ingresa tu apellido paterno" : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _apellidoMaternoCtrl,
          decoration: _buildDecoration("Apellido Materno"),
        ),
        const SizedBox(height: 8),
        // Género como dropdown con búsqueda
        SearchableDropdownField(
          label: "Género",
          controller: _generoCtrl,
          items: AppConstants.genders,
          validator: (value) => value == null || value.isEmpty ? "Selecciona tu género" : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fechaNacCtrl,
          readOnly: true,
          decoration: _buildDecoration("Fecha de Nacimiento (DD/MM/AAAA)"),
          onTap: _selectFechaNacimiento,
          validator: (value) => value == null || value.isEmpty ? "Selecciona tu fecha de nacimiento" : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _telefonoCtrl,
          decoration: _buildDecoration("Teléfono"),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _correoCtrl,
          decoration: _buildDecoration("Correo Electrónico"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Ingresa tu correo";
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value)) {
              return "Correo inválido";
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmCorreoCtrl,
          decoration: _buildDecoration("Confirmar Correo"),
          validator: (value) {
            if (value != _correoCtrl.text) {
              return "El correo no coincide";
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordCtrl,
          obscureText: true,
          decoration: _buildDecoration("Contraseña"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "La contraseña es obligatoria";
            }
            if (value.length < 6) {
              return "Debe tener al menos 6 caracteres";
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordCtrl,
          obscureText: true,
          decoration: _buildDecoration("Confirmar Contraseña"),
          validator: (value) {
            if (value != _passwordCtrl.text) {
              return "Las contraseñas no coinciden";
            }
            return null;
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 2: INFORMACIÓN MÉDICA
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep2MedicalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Datos médicos principales."),
        const SizedBox(height: 8),
        TextFormField(
          controller: _diagnosticoCtrl,
          decoration: _buildDecoration("Diagnóstico"),
          validator: (value) => value == null || value.isEmpty ? "Ingresa el diagnóstico" : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _gradoCtrl,
          decoration: _buildDecoration("Grado (ej. I, II, III)"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _restriccionesCtrl,
          decoration: _buildDecoration("Restricciones de Alimentación"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _otrasEnfermedadesCtrl,
          decoration: _buildDecoration("Otras Enfermedades"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tallaCtrl,
          decoration: _buildDecoration("Talla (cm)"),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _pesoCtrl,
          decoration: _buildDecoration("Peso (kg)"),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 3: SEGURO Y CENTRO
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep3InsuranceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Selecciona el tipo de seguro y centro de tratamiento."),
        const SizedBox(height: 8),
        SearchableDropdownField(
          label: "Tipo de Seguro",
          controller: _tipoSeguroCtrl,
          items: AppConstants.insuranceTypes,
          validator: (value) => value == null || value.isEmpty ? "Selecciona un tipo de seguro" : null,
        ),
        const SizedBox(height: 8),
        SearchableDropdownField(
          label: "Centro de Tratamiento",
          controller: _centroTratamientoCtrl,
          items: AppConstants.medicalInstitutionsPeru,
          validator: (value) => value == null || value.isEmpty ? "Selecciona un centro" : null,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 4: DATOS DE FAMILIAR
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep4FamilyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Información de un familiar o contacto de emergencia."),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nombreFamiliarCtrl,
          decoration: _buildDecoration("Nombre de Familiar"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _relacionFamiliarCtrl,
          decoration: _buildDecoration("Relación con el Usuario"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _numeroEmergenciaCtrl,
          decoration: _buildDecoration("Número de Emergencia"),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 5: CONFIRMACIÓN FINAL
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep5FinalConfirm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Paso final: Confirmar y aceptar términos."),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text(
            "He leído y acepto los Términos y Condiciones de la aplicación.",
          ),
          value: _aceptoTerminos,
          onChanged: (value) {
            setState(() {
              _aceptoTerminos = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (!_aceptoTerminos)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "Debes aceptar los términos para continuar.",
              style: TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 16),
        // Podrías mostrar un resumen final de los datos, si quieres
        // o simplemente validas el checkbox y sigues.
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DECORATION HELPER
  // ─────────────────────────────────────────────────────────────────────────────
  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
