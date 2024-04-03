// Detay sayfası olaylarını temsil eden abstract (soyut) sınıf.
abstract class DetailEvent {}

// Belirli bir blogun detaylarını almak için kullanılan olay sınıfı.
class FetchDetailId extends DetailEvent {
  // Alınmak istenen blogun benzersiz kimliği.
  final String id;

  // FetchDetailId sınıfının yapılandırıcı metodu.
  FetchDetailId({required this.id});
}

// Detay sayfasını sıfırlamak için kullanılan olay sınıfı.
class ResetEvent extends DetailEvent {}
