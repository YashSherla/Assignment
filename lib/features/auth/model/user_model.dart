class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final String email;
  final int wallet;

  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.email,
    required this.wallet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'email': email,
      'wallet': wallet
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      wallet: map['wallet'] as int,
    );
  }
}
