class ArticleModel {
  final String? title;
  final String? description;
  final String? content;
  final String? urlToImage;
  final String? url;
  final String? publishedAt;
  final String? author;
  final SourceModel? source;

  ArticleModel({
    this.title,
    this.description,
    this.content,
    this.urlToImage,
    this.url,
    this.publishedAt,
    this.author,
    this.source,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'],
      description: json['description'],
      content: json['content'],
      urlToImage: json['urlToImage'],
      url: json['url'],
      publishedAt: json['publishedAt'],
      author: json['author'],
      source: json['source'] != null ? SourceModel.fromJson(json['source']) : null,
    );
  }
}

class SourceModel {
  final String? id;
  final String? name;

  SourceModel({this.id, this.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
