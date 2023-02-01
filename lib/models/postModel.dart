class postModel {
  final int id, likecount, userlike;
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
        likecount = json['likecount'],
        userlike = json['userlike'],
        date = json['date'],
        youtube_data = json['youtube_data'];
}
