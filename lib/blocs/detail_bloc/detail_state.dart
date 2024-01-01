import 'package:miniblogapp/models/blog.dart';

// detail sayfasının farklı durumlarını temsil eden state sınıfı
abstract class DetailState {}

// Başlangıç durumu, proje ilk açıldığında kullanılır.
class DetailInitial extends DetailState {}

// Veri yükleniyor durumu, verilerin alınması sırasında kullanılır.
class DetailLoading extends DetailState {}

// Veriler yüklendi durumu, veriler başarılı bir şekilde alındığında kullanılır.
class DetailLoaded extends DetailState {
  // Blog nesnesini içeren DetailLoaded durumu.
  final Blog blogs;

  // DetailLoaded sınıfının yapılandırıcı metodu.
  DetailLoaded({required this.blogs});
}

// Hata durumu, veriler alınırken bir hata oluştuğunda kullanılır.
class DetailError extends DetailState {}
