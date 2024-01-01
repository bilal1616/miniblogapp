import 'package:image_picker/image_picker.dart';

// Makale (blog) işlemleri için kullanılan farklı olayları temsil eden abstract (soyut) sınıf.
abstract class ArticleEvent {}

// Makaleleri çekme olayı, mevcut makaleleri çekmek için kullanılır.
class FetchArticles extends ArticleEvent {}

// Yeni bir blog eklemek için kullanılan olay.
class AddBlogEvent extends ArticleEvent {
  // Blog başlığı.
  final String title;
  // Blog içeriği.
  final String content;
  // Blog yazarı (author).
  final String author;
  // Blog görseli (image), isteğe bağlıdır (null olabilir).
  final XFile? image;

  // AddBlogEvent sınıfının yapılandırıcı metodu.
  AddBlogEvent({required this.title, required this.content, required this.author, this.image});
}

// Blog eklenme olayı, yeni bir blog başarıyla eklenirse kullanılır.
class BlogAddedEvent extends ArticleEvent {}
