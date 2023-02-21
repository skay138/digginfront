class postModel {
  final int id;
  final String title,
      uid,
      youtube_link,
      youtube_title,
      youtube_thumb,
      nickname,
      date;
  final String? content;

  postModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        title = json['title'],
        content = json['content'],
        youtube_link = json['youtube_link'],
        youtube_title = json['youtube_title'],
        youtube_thumb = json['youtube_thumb'],
        nickname = json['nickname'],
        date = json['date'];
}

class postLikeModel {
  final bool status;
  final int count;

  postLikeModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        count = json['count'];
}
