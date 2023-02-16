class postModel {
  final int id, like_count, userlike;
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
        like_count = json['like_count'],
        userlike = json['userlike'],
        date = json['date'];
}
