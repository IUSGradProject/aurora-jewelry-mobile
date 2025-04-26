class StyleModel {
  final int id;
  final String name;

  StyleModel({required this.id, required this.name});

  factory StyleModel.fromJson(Map<String, dynamic> json) {
    return StyleModel(id: json['id'] as int, name: json['name'] as String);
  }
}
