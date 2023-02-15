class UserFields {
  static String id = "id";
  static String username = "username";
  static String name = "name";
  static String state = "state";
  static String avatarUrl = "avatar_url";
}

class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.state,
    required this.avatarUrl,
  });

  final int id;
  final String username;
  final String name;
  final String state;
  final String avatarUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as int? ?? 0,
      username: json["username"] as String? ?? "",
      name: json["name"] as String? ?? "",
      state: json["state"] as String? ?? "",
      avatarUrl: json["avatar_url"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.name: name,
        UserFields.state: state,
        UserFields.avatarUrl: avatarUrl,
      };

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? state,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      state: state ?? this.state,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}