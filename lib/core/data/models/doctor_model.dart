class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final String profileImage;
  // NUEVO:
  final double consultationFee;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.profileImage,
    this.consultationFee = 50.0, // valor por defecto
  });
}
