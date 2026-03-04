class InstructorModel {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final double rating;
  final String students;
  final String about;

  InstructorModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.rating,
    required this.students,
    required this.about,
  });

  factory InstructorModel.fromMap(Map<String, dynamic> data, String documentId) {
    return InstructorModel(

      id: documentId.trim(), 
      name: data['instructorName'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['instructorImage'] ?? '',
      
      rating: double.tryParse(data['rating']?.toString() ?? '0.0') ?? 0.0,
      students: data['studentCount'] ?? '0',
      about: data['aboutInfo'] ?? '',
    );
  }
}