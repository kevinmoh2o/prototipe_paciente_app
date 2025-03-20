import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/services/patient_local_service.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/doctor_model.dart';
import 'package:provider/provider.dart';

class HomeProvider extends ChangeNotifier {
  String _userName = "";
  String _userAvatar = "assets/images/avatar_female.png";
  List<DoctorModel> _topDoctors = [];

  String get userName => _userName;
  String get userAvatar => _userAvatar;
  List<DoctorModel> get topDoctors => _topDoctors;

  HomeProvider() {
    _topDoctors = AppConstants.topDoctors;
  }

  void loadUserData(BuildContext context) async {
    final PatientLocalService patientLocalService = PatientLocalService();
    //final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    //final PatientModel? storedPatient = await _patientLocalService.getPatient();
    final patient = await patientLocalService.getPatient();

    if (patient != null) {
      _userName = '${patient.nombre!} ${patient.apellidoPaterno!} ${patient.apellidoMaterno!}';
      _userAvatar = patient.genero == "Masculino" ? "assets/images/avatar_male.png" : "assets/images/avatar_female.png";

      notifyListeners();
    }
  }
}
