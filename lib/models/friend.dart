class Friend {
  Friend({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  Friend.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  Friend copyWith({String? name, String? id, String? email}) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      email: this.email,
    );
  }
}
