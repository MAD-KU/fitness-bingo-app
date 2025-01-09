class ArticleModel {
  String? id;
  String? title;
  String? content;
  String? youtubeLink;

  ArticleModel({this.id, this.title, this.content, this.youtubeLink});

  ArticleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    youtubeLink = json['youtubeLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['youtubeLink'] = this.youtubeLink;
    return data;
  }
}