import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../repositories/news_repository_impl.dart';
import '../usecases/get_news_usecase.dart';
import '../viewmodels/news_viewmodel.dart';
import '../widgets/article_card.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NewsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final repo = NewsRepositoryImpl();
    final useCase = GetNewsByCategoryUseCase(repo);
    _viewModel = NewsViewModel(useCase);
    _viewModel.fetchNews('general');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News App')),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_viewModel.state) {
      case NewsState.loading:
      case NewsState.initial:
        return _LoadingList();

      case NewsState.error:
        return _ErrorView(
          message: _viewModel.errorMessage,
          onRetry: () => _viewModel.fetchNews('general'),
        );

      case NewsState.success:
        if (_viewModel.articles.isEmpty) {
          return const Center(
            child: Text('No articles found.',
                style: TextStyle(color: AppColors.textSecondary)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: _viewModel.articles.length,
          itemBuilder: (_, i) => ArticleCard(article: _viewModel.articles[i]),
        );
    }
  }
}

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 5,
      itemBuilder: (context, index) => _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(height: 180, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 80, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 14, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 4),
                  Container(height: 14, width: 200, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 60, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'Could not load news',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
