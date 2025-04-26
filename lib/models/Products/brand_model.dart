class BrandModel {
  final int id;
  final String name;

  BrandModel({required this.id, required this.name});
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(id: json['id'] as int, name: json['name'] as String);
  }
}
