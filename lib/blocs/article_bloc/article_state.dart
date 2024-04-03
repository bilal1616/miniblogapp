import 'package:miniblogapp/models/blog.dart';

// Makale (blog) işlemleri için kullanılan farklı durumları temsil eden abstract (soyut) sınıf.
abstract class ArticleState {}

// Başlangıç durumu, proje ilk açıldığında kullanılır.
class ArticlesInitial extends ArticleState {}

// Makalelerin yükleniyor durumu, verilerin alınması sırasında kullanılır.
class ArticlesLoading extends ArticleState {}

// Makalelerin yüklendiği durum, veriler başarılı bir şekilde alındığında kullanılır.
class ArticlesLoaded extends ArticleState {
  // Alınan blog verilerini içeren ArticlesLoaded durumu.
  final List<Blog> blogs;

  // ArticlesLoaded sınıfının yapılandırıcı metodu.
  ArticlesLoaded({required this.blogs});
}

// Makalelerin yüklenemediği hata durumu, veriler alınırken bir hata oluştuğunda kullanılır.
class ArticlesError extends ArticleState {}

// Blog ekleniyor durumu, yeni bir blog eklenirken kullanılır.
class BlogAdding extends ArticleState {}

// Blog eklenme durumu, yeni bir blog başarıyla eklenirse kullanılır.
class BlogAdded extends ArticleState {}

// Blog eklenemediği hata durumu, yeni bir blog eklenirken bir hata oluştuğunda kullanılır.
class BlogAddError extends ArticleState {}
