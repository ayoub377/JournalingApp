
class User{

  int? id;
  String? name;
  String? email;
  String? password;
  String? imagePath;
  // to json and from json
  User({this.id, this.name, this.email, this.password, this.imagePath});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    imagePath: json["imagePath"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "imagePath": imagePath,
  };

}