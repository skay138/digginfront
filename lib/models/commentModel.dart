class commentModel {
  final int id;
  final int? parent_id;
  final String uid, nickname;
  final String? image, content;
  final List? taguser;

  commentModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        parent_id = json['parent_id'],
        uid = json['uid'],
        nickname = json['nickname'],
        image = json['image'],
        content = json['content'],
        taguser = json['taguser'];
}
