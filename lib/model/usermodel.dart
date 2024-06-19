class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}