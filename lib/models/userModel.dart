class userModel {
  final String uid, email, nickname;
  final String? introduce, image, gender, birth;
  final bool is_active;

  userModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        nickname = json['nickname'],
        introduce = json['introduce'],
        image = json['image'],
        gender = json['gender'],
        birth = json['birth'],
        is_active = json['is_active'];
}
