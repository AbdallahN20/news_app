import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import 'news_repository.dart';


class NewsRepositoryImpl implements NewsRepository {
  static const String _apiKey = '3a99ca2637d74b8bb9bf3fc1faf11180';
  static const String _baseUrl = 'https://newsapi.org/v2';

  @override
  Future<List<ArticleModel>> getNewsByCategory(String category) async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines?category=$category&country=us&pageSize=20',
    );

    final response = await http.get(
      url,
      headers: {
        'X-Api-Key': _apiKey,
        'User-Agent': 'NewsApp/1.0',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articles = data['articles'] ?? [];
      return articles
          .map((json) => ArticleModel.fromJson(json))
          .where((a) => a.title != null && a.title != '[Removed]')
          .toList();
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Error ${response.statusCode}');
    }
  }
}

