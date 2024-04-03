import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblogapp/blocs/detail_bloc/detail_event.dart';
import 'package:miniblogapp/blocs/detail_bloc/detail_state.dart';
import 'package:miniblogapp/repositories/article_repository.dart';

// Detay sayfası için kullanılan BLoC (Business Logic Component) sınıfı.
class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final ArticleRepository articleRepository;

  // DetailBloc sınıfının yapılandırıcı metodu.
  DetailBloc({required this.articleRepository}) : super(DetailInitial()) {
    // FetchDetailId olayını dinleyerek _onFetchDetailId metodu çalıştırılır.
    on<FetchDetailId>(_onFetchDetailId);
    // ResetEvent olayını dinleyerek _onResetEvent metodu çalıştırılır.
    on<ResetEvent>(_onResetEvent);
  }

  // Detay sayfasını yüklemek için kullanılan metod.
  void _onFetchDetailId(FetchDetailId event, Emitter<DetailState> emit) async {
    // Detay sayfasının yükleniyor durumuna geçirilmesi.
    emit(DetailLoading());

    try {
      // Belirli bir blogun detaylarını almak için repository'den istek yapılır.
      final articles = await articleRepository.fetchBlogId(event.id);
      // Detay sayfasının yüklendiği duruma geçirilmesi ve verilerin iletilmesi.
      emit(DetailLoaded(
        blogs: articles,
      ));
    } catch (e) {
      // Hata durumunda detay sayfasının hata durumuna geçirilmesi.
      emit(DetailError());
    }
  }

  // Detay sayfasını sıfırlamak için kullanılan metod.
  void _onResetEvent(ResetEvent event, Emitter<DetailState> emit) async {
    // Detay sayfasının başlangıç durumuna geri döndürülmesi.
    emit(DetailInitial());
  }
}
