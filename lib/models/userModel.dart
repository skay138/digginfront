class userModel {
  final String uid, email, nickname;
  final String? introduce, image, bgimage, gender, birth;
  final bool is_active, is_signed;

  userModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        nickname = json['nickname'],
        introduce = json['introduce'],
        image = json['image'],
        bgimage = json['bgimage'],
        gender = json['gender'],
        birth = json['birth'],
        is_active = json['is_active'],
        is_signed = json['is_signed'];
}
