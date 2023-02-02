class postModel {
  final int id, like_count, userlike;
  final String title, uid, youtube_link, nickname, date;
  final String? content;
  final Map youtube_data;

  postModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        title = json['title'],
        content = json['content'],
        youtube_link = json['youtube_link'],
        nickname = json['nickname'],
        like_count = json['like_count'],
        userlike = json['userlike'],
        date = json['date'],
        youtube_data = json['youtube_data'];
}
