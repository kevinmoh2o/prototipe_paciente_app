import 'package:paciente_app/features/medication/data/models/medication_model.dart';

class MedicationService {
  // Ejemplo: data mock

  final List<MedicationModel> _allMedications = [
    MedicationModel(
      id: '1',
      name: 'Oxaliplatino',
      description: 'Medicamento para quimioterapia...',
      price: 220.0,
      imageUrl: 'assets/meds/oxaliplatino.png',
      presentation: ['100mg', '200mg'],
      pharmacy: 'Farmacia ABC',
      discountPercentage: 10.0,
      stock: 5
    ),
    MedicationModel(
      id: '2',
      name: 'Paracetamol',
      description: 'Analgésico y antipirético...',
      price: 15.0,
      imageUrl: 'assets/meds/paracetamol.png',
      presentation: ['500mg', '1g', '250mg'],
      pharmacy: 'Farmacia XYZ',
      discountPercentage: 5.0,
      stock: 15
    ),
    MedicationModel(
      id: '3',
      name: 'Cisplatino',
      description: 'Usado en el tratamiento de cáncer de ovario y testicular...',
      price: 250.0,
      imageUrl: 'assets/meds/cisplatino.png',
      presentation: ['50mg', '100mg'],
      pharmacy: 'Farmacia Omega',
      discountPercentage: 15.0,
      stock: 3
    ),
    MedicationModel(
      id: '4',
      name: 'Doxorrubicina',
      description: 'Medicamento utilizado en diversos tipos de cáncer...',
      price: 300.0,
      imageUrl: 'assets/meds/doxorrubicina.png',
      presentation: ['20mg', '50mg'],
      pharmacy: 'Farmacia Delta',
      discountPercentage: 12.0,
      stock: 4
    ),
    MedicationModel(
      id: '5',
      name: 'Docetaxel',
      description: 'Tratamiento para cáncer de mama y próstata...',
      price: 350.0,
      imageUrl: 'assets/meds/docetaxel.png',
      presentation: ['20mg', '80mg'],
      pharmacy: 'Farmacia Beta',
      discountPercentage: 8.0,
      stock: 5
    ),
    MedicationModel(
      id: '6',
      name: 'Paclitaxel',
      description: 'Quimioterapia usada en cáncer de mama, ovario y pulmón...',
      price: 400.0,
      imageUrl: 'assets/meds/paclitaxel.png',
      presentation: ['100mg', '300mg'],
      pharmacy: 'Farmacia Sigma',
      discountPercentage: 5.0,
      stock: 8
    ),
    MedicationModel(
      id: '7',
      name: 'Metotrexato',
      description: 'Usado en cáncer de piel y leucemia...',
      price: 180.0,
      imageUrl: 'assets/meds/metotrexato.png',
      presentation: ['2.5mg', '5mg'],
      pharmacy: 'Farmacia Omega',
      discountPercentage: 10.0,
      stock: 5
    ),
    MedicationModel(
      id: '8',
      name: 'Vincristina',
      description: 'Medicamento usado para leucemias y linfomas...',
      price: 220.0,
      imageUrl: 'assets/meds/vincristina.png',
      presentation: ['1mg', '5mg'],
      pharmacy: 'Farmacia Alpha',
      discountPercentage: 20.0,
      stock: 1
    ),
    MedicationModel(
      id: '9',
      name: 'Fluorouracilo',
      description: 'Usado en cáncer colorectal y de mama...',
      price: 250.0,
      imageUrl: 'assets/meds/fluorouracilo.png',
      presentation: ['500mg', '1g'],
      pharmacy: 'Farmacia Zeta',
      discountPercentage: 15.0,
      stock: 10
    ),
    MedicationModel(
      id: '10',
      name: 'Tamoxifeno',
      description: 'Tratamiento para cáncer de mama...',
      price: 150.0,
      imageUrl: 'assets/meds/tamoxifeno.png',
      presentation: ['10mg', '20mg'],
      pharmacy: 'Farmacia Delta',
      discountPercentage: 7.0,
      stock: 18
    ),
    MedicationModel(
      id: '11',
      name: 'Trastuzumab',
      description: 'Medicamento usado en cáncer de mama HER2 positivo...',
      price: 500.0,
      imageUrl: 'assets/meds/trastuzumab.png',
      presentation: ['150mg', '440mg'],
      pharmacy: 'Farmacia ABC',
      discountPercentage: 12.0,
      stock: 51
    ),
    MedicationModel(
      id: '12',
      name: 'Leucovorina',
      description: 'Ayuda a reducir los efectos secundarios de la quimioterapia...',
      price: 100.0,
      imageUrl: 'assets/meds/leucovorina.png',
      presentation: ['50mg', '200mg'],
      pharmacy: 'Farmacia Zeta',
      discountPercentage: 5.0,
      stock: 26
    ),
    MedicationModel(
      id: '13',
      name: 'Bevacizumab',
      description: 'Tratamiento para cáncer colorectal, pulmón y riñón...',
      price: 600.0,
      imageUrl: 'assets/meds/bevacizumab.png',
      presentation: ['100mg', '400mg'],
      pharmacy: 'Farmacia Beta',
      discountPercentage: 10.0,
      stock: 23
    ),
    MedicationModel(
      id: '14',
      name: 'Lapatinib',
      description: 'Medicamento utilizado en cáncer de mama HER2 positivo...',
      price: 400.0,
      imageUrl: 'assets/meds/lapatinib.png',
      presentation: ['250mg', '500mg'],
      pharmacy: 'Farmacia Alpha',
      discountPercentage: 8.0,
      stock: 19
    ),
    MedicationModel(
      id: '15',
      name: 'Erlotinib',
      description: 'Tratamiento para cáncer de pulmón de células no pequeñas...',
      price: 450.0,
      imageUrl: 'assets/meds/erlotinib.png',
      presentation: ['150mg', '300mg'],
      pharmacy: 'Farmacia Sigma',
      discountPercentage: 5.0,
      stock: 0
    ),
    MedicationModel(
      id: '16',
      name: 'Imatinib',
      description: 'Usado para tratar leucemia mieloide crónica y otros tipos de cáncer...',
      price: 500.0,
      imageUrl: 'assets/meds/imatinib.png',
      presentation: ['100mg', '400mg'],
      pharmacy: 'Farmacia Zeta',
      discountPercentage: 10.0,
      stock: 2
    ),
    MedicationModel(
      id: '17',
      name: 'Rituximab',
      description: 'Tratamiento para linfoma no Hodgkin...',
      price: 350.0,
      imageUrl: 'assets/meds/rituximab.png',
      presentation: ['500mg', '100mg'],
      pharmacy: 'Farmacia Omega',
      discountPercentage: 15.0,
      stock: 44
    ),
    MedicationModel(
      id: '18',
      name: 'Cyclophosphamide',
      description: 'Quimioterapia para cáncer de mama, ovario y linfoma...',
      price: 200.0,
      imageUrl: 'assets/meds/cyclophosphamide.png',
      presentation: ['100mg', '200mg'],
      pharmacy: 'Farmacia Alpha',
      discountPercentage: 5.0,
      stock: 4
    ),
    MedicationModel(
      id: '19',
      name: 'Bortezomib',
      description: 'Usado en el tratamiento del mieloma múltiple...',
      price: 450.0,
      imageUrl: 'assets/meds/bortezomib.png',
      presentation: ['3.5mg', '5mg'],
      pharmacy: 'Farmacia Delta',
      discountPercentage: 20.0,
      stock: 9
    ),
    MedicationModel(
      id: '20',
      name: 'Lenalidomida',
      description: 'Tratamiento para mieloma múltiple y linfoma...',
      price: 700.0,
      imageUrl: 'assets/meds/lenalidomida.png',
      presentation: ['10mg', '25mg'],
      pharmacy: 'Farmacia Zeta',
      discountPercentage: 12.0,
      stock: 1
    ),
    // ... Continue adding the remaining 30 medications following the same structure
  ];

  Future<List<MedicationModel>> fetchMedications() async {
    // Simula un delay de red
    await Future.delayed(const Duration(seconds: 1));
    return _allMedications;
  }
}
