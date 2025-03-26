class PatientModel {
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? genero;
  DateTime? fechaNacimiento;
  String? telefono;

  String? correo;
  String? password;

  // Datos médicos
  String? diagnostico;
  String? grado;
  String? restriccionesAlimentacion;
  String? otrasEnfermedades;
  double? talla;
  double? peso;

  // Seguro y centro
  String? tipoSeguro;
  String? centroTratamiento;

  // Datos familiar
  String? nombreFamiliar;
  String? relacionFamiliar;
  String? numeroEmergencia;

  // Para checkbox de términos
  bool aceptoTerminos;
  String? activePlan;

  PatientModel({
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.genero,
    this.fechaNacimiento,
    this.telefono,
    this.correo,
    this.password,
    this.diagnostico,
    this.grado,
    this.restriccionesAlimentacion,
    this.otrasEnfermedades,
    this.talla,
    this.peso,
    this.tipoSeguro,
    this.centroTratamiento,
    this.nombreFamiliar,
    this.relacionFamiliar,
    this.numeroEmergencia,
    this.aceptoTerminos = false,
    this.activePlan = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'correo': correo,
      'password': password,
      'diagnostico': diagnostico,
      'grado': grado,
      'restriccionesAlimentacion': restriccionesAlimentacion,
      'otrasEnfermedades': otrasEnfermedades,
      'talla': talla,
      'peso': peso,
      'tipoSeguro': tipoSeguro,
      'centroTratamiento': centroTratamiento,
      'nombreFamiliar': nombreFamiliar,
      'relacionFamiliar': relacionFamiliar,
      'numeroEmergencia': numeroEmergencia,
      'aceptoTerminos': aceptoTerminos,
      'activePlan': activePlan,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    DateTime? fecha;
    if (map['fechaNacimiento'] != null) {
      fecha = DateTime.tryParse(map['fechaNacimiento']);
    }

    return PatientModel(
      nombre: map['nombre'],
      apellidoPaterno: map['apellidoPaterno'],
      apellidoMaterno: map['apellidoMaterno'],
      genero: map['genero'],
      fechaNacimiento: fecha,
      telefono: map['telefono'],
      correo: map['correo'],
      password: map['password'],
      diagnostico: map['diagnostico'],
      grado: map['grado'],
      restriccionesAlimentacion: map['restriccionesAlimentacion'],
      otrasEnfermedades: map['otrasEnfermedades'],
      talla: map['talla'] != null ? (map['talla'] as num).toDouble() : null,
      peso: map['peso'] != null ? (map['peso'] as num).toDouble() : null,
      tipoSeguro: map['tipoSeguro'],
      centroTratamiento: map['centroTratamiento'],
      nombreFamiliar: map['nombreFamiliar'],
      relacionFamiliar: map['relacionFamiliar'],
      numeroEmergencia: map['numeroEmergencia'],
      aceptoTerminos: map['aceptoTerminos'] ?? false,
      activePlan: map['activePlan'],
    );
  }

  @override
  String toString() {
    return 'PatientModel(nombre: $nombre, apellidoPaterno: $apellidoPaterno, apellidoMaterno: $apellidoMaterno, genero: $genero, fechaNacimiento: $fechaNacimiento, telefono: $telefono, correo: $correo, password: $password, diagnostico: $diagnostico, grado: $grado, restriccionesAlimentacion: $restriccionesAlimentacion, otrasEnfermedades: $otrasEnfermedades, talla: $talla, peso: $peso, tipoSeguro: $tipoSeguro, centroTratamiento: $centroTratamiento, nombreFamiliar: $nombreFamiliar, relacionFamiliar: $relacionFamiliar, numeroEmergencia: $numeroEmergencia, aceptoTerminos: $aceptoTerminos, activePlan: $activePlan)';
  }
}
