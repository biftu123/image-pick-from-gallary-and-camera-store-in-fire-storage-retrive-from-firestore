// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class user {
  String name;
  String phonenumber;
  String imageurl;
  user({required this.name, required this.phonenumber, required this.imageurl});

  user copyWith({
    String? name,
    String? phonenumber,
    String? imageurl,
  }) {
    return user(
      name: name ?? this.name,
      phonenumber: phonenumber ?? this.phonenumber,
      imageurl: imageurl ?? this.imageurl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phonenumber': phonenumber,
      'imageurl': imageurl,
    };
  }

  factory user.fromMap(Map<String, dynamic> map) {
    return user(
      name: map['name'] as String,
      phonenumber: map['phonenumber'] as String,
      imageurl: map['imageurl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory user.fromJson(String source) =>
      user.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'user(name: $name, phonenumber: $phonenumber, imageurl: $imageurl)';

  @override
  bool operator ==(covariant user other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phonenumber == phonenumber &&
        other.imageurl == imageurl;
  }

  @override
  int get hashCode => name.hashCode ^ phonenumber.hashCode ^ imageurl.hashCode;
}
