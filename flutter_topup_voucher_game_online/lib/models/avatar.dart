class Avatar {
  final int? id;
  final String? name;
  final String? imageUrl;

  Avatar({required this.id, required this.name, required this.imageUrl});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'] ?? 0,
      name: json['name'] ?? "null",
      imageUrl: json['imageUrl'] ?? 'null',
    );
  }

  
  static List<Avatar> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Avatar.fromJson(json)).toList();
  }
}
