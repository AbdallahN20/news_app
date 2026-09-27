import '../models/article_model.dart';

abstract class NewsRepository {
  Future<List<ArticleModel>> getNewsByCategory(String category);
}
