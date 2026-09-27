import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../usecases/get_news_usecase.dart';

enum NewsState { initial, loading, success, error }

class NewsViewModel extends ChangeNotifier {
  final GetNewsByCategoryUseCase _useCase;

  NewsViewModel(this._useCase);

  NewsState _state = NewsState.initial;
  List<ArticleModel> _articles = [];
  String _errorMessage = '';

  NewsState get state => _state;
  List<ArticleModel> get articles => _articles;
  String get errorMessage => _errorMessage;

  Future<void> fetchNews(String category) async {
    _state = NewsState.loading;
    notifyListeners();

    try {
      _articles = await _useCase.execute(category);
      _state = NewsState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = NewsState.error;
    }

    notifyListeners();
  }
}
