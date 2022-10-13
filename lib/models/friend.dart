class Friend {
  Friend({required this.id, required this.name});

  final String id;
  final String name;

  Friend.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
