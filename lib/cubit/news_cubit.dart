import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/api.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(BuildContext context) => BlocProvider.of<NewsCubit>(context);

  Future<void> fetchNews() async {
    emit(NewsLoadingState());

    try {
      final newsModel = await Api.getArticles();
      final articlesList = newsModel.articles ?? [];
      emit(NewsSuccessState(articlesList));
    } catch (error) {
      emit(NewsErrorState(error.toString()));
    }
  }
}
