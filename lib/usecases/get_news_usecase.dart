import '../models/article_model.dart';
import '../repositories/news_repository.dart';

class GetNewsByCategoryUseCase {
  final NewsRepository _repository;

  GetNewsByCategoryUseCase(this._repository);

  Future<List<ArticleModel>> execute(String category) {
    return _repository.getNewsByCategory(category);
  }
}
