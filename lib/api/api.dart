import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

class Api {
  static const String _host = 'newsapi.org';
  static const String _endpoint = '/v2/everything';
  static const String _apiKey = '7fe358c9c7b645378246612676f839b6';

  static Future<NewsModel> getArticles({String query = 'bitcoin'}) async {
    final queryParameters = {
      'q': query,
      'apiKey': _apiKey,
      'sortBy': 'publishedAt',
      'language': 'en',
      'pageSize': '25',
    };

    final uri = Uri.https(_host, _endpoint, queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'NewsAppClient/1.0',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return NewsModel.fromJson(data);
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception(
        errorBody['message'] ?? 'Failed to load news ${response.statusCode}',
      );
    }
  }
}
