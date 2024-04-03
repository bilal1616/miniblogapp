import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblogapp/blocs/article_bloc/article_event.dart';
import 'package:miniblogapp/blocs/article_bloc/article_state.dart';
import 'package:miniblogapp/repositories/article_repository.dart';

// Makalelerle ilgili iş mantığını yöneten BLoC (Business Logic Component) sınıfı.
class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository articleRepository;

  // ArticleBloc sınıfının yapılandırıcı metodu.
  ArticleBloc({required this.articleRepository}) : super(ArticlesInitial()) {
    // Olaylara yanıt olarak hangi işlevlerin çalışacağını belirlemek için 'on' metodu kullanılır.
    on<FetchArticles>(_onFetchArticles);
    on<AddBlogEvent>(_onAddBlog);
    on<BlogAddedEvent>((event, emit) => emit(ArticlesInitial()));
  }

  // Makaleleri çekme olayına yanıt olarak çalışacak işlev.
  void _onFetchArticles(FetchArticles event, Emitter<ArticleState> emit) async {
    emit(ArticlesLoading());

    try {
      // Makaleleri çekmek için ArticleRepository sınıfını kullanıyoruz.
      final articles = await articleRepository.fetchAllBlogs();
      emit(ArticlesLoaded(
        blogs: articles,
      ));
    } catch (e) {
      emit(ArticlesError());
    }
  }

  // Yeni bir blog eklemek için çalışacak işlev.
  void _onAddBlog(AddBlogEvent event, Emitter<ArticleState> emit) async {
    emit(BlogAdding());
    try {
      // Blog eklemek için ArticleRepository sınıfını kullanıyoruz.
      await articleRepository.addBlog(
          event.title, event.content, event.author, event.image);
      emit(BlogAdded());
      this.add(BlogAddedEvent());
    } catch (e) {
      emit(BlogAddError());
    }
  }
}
