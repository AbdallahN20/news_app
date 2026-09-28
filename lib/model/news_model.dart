import 'articles.dart';

class NewsModel {
  final String? status;
  final int? totalResults;
  final List<Articles>? articles;

  NewsModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    List<Articles>? parsedArticles;
    if (json['articles'] != null) {
      parsedArticles = (json['articles'] as List)
          .map((item) => Articles.fromJson(item as Map<String, dynamic>))
          .where((art) => art.title != null && art.title != '[Removed]')
          .toList();
    }

    return NewsModel(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      articles: parsedArticles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles?.map((art) => art.toJson()).toList(),
    };
  }
}
