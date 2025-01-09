class User {
  bool online;
  String email;
  String nombre;
  String uid;

  User({
    required this.online,
    required this.email,
    required this.nombre,
    required this.uid
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        online: json["online"],
        nombre: json["name"],
        email: json["email"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
    };

}