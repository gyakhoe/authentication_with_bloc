import 'dart:convert';

class AuthenticationDetail {
  final bool? isValid;
  final String? uid;
  final String? photoUrl;
  final String? email;
  final String? name;

  AuthenticationDetail({
    required this.isValid,
    this.uid,
    this.photoUrl,
    this.email,
    this.name,
  });

  AuthenticationDetail copyWith({
    bool? isValid,
    String? uid,
    String? photoUrl,
    String? email,
    String? name,
  }) {
    return AuthenticationDetail(
      isValid: isValid ?? this.isValid,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isValid': isValid,
      'uid': uid,
      'photoUrl': photoUrl,
      'email': email,
      'name': name,
    };
  }

  factory AuthenticationDetail.fromMap(Map<String, dynamic>? map) {
    return AuthenticationDetail(
      isValid: map?['isValid'],
      uid: map?['uid'],
      photoUrl: map?['photoUrl'],
      email: map?['email'],
      name: map?['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationDetail.fromJson(String source) =>
      AuthenticationDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthenticationDetail(isValid: $isValid, uid: $uid, photoUrl: $photoUrl, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AuthenticationDetail &&
        o.isValid == isValid &&
        o.uid == uid &&
        o.photoUrl == photoUrl &&
        o.email == email &&
        o.name == name;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        uid.hashCode ^
        photoUrl.hashCode ^
        email.hashCode ^
        name.hashCode;
  }
}
