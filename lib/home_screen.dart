import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'article_detail_screen.dart';
import 'cubit/news_cubit.dart';
import 'cubit/news_state.dart';
import 'image_item_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..fetchNews(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1877F2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'News App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState || state is NewsInitialState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1877F2),
              ),
            );
          }

          if (state is NewsErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                      ),
                      onPressed: () => NewsCubit.get(context).fetchNews(),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NewsSuccessState) {
            final articles = state.articles;

            if (articles.isEmpty) {
              return const Center(
                child: Text(
                  'No news available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: articles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final article = articles[index];

                return ImageItemWidget(
                  image: article.urlToImage ?? '',
                  title: article.title ?? '',
                  category: (article.sourceName != null && article.sourceName!.isNotEmpty)
                      ? article.sourceName!
                      : 'Europe',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
