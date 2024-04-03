// Flutter'ın malzeme tasarımı widget'larını ve diğer temel özelliklerini içe aktarır.
import 'package:flutter/material.dart';
// flutter_bloc paketini içe aktarır, BLoC mimarisini kullanım için gerekli.
import 'package:flutter_bloc/flutter_bloc.dart';
// DetailBloc ile ilgili olayları ve durumları içe aktarır.
import 'package:miniblogapp/blocs/detail_bloc/detail_event.dart';
import 'package:miniblogapp/blocs/detail_bloc/detail_state.dart';
import 'package:miniblogapp/blocs/detail_bloc/detail_bloc.dart';

// BlogDetails adında bir StatefulWidget tanımlar. Bu widget, bir blog detay sayfasını temsil eder.
class BlogDetails extends StatefulWidget {
  // Constructor (Yapıcı), gerekli parametrelerin geçilmesini sağlar.
  const BlogDetails({Key? key, required this.id}) : super(key: key);

  // Blog'un ID'sini tutar.
  final String id;

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

// BlogDetails için state sınıfı.
class _BlogDetailsState extends State<BlogDetails> {
  // Widget'ın görsel yapısını oluşturan build metodunu tanımlar.
  @override
  Widget build(BuildContext context) {
    // BlocBuilder, BLoC mimarisindeki durum değişikliklerini dinler.
    return BlocBuilder<DetailBloc, DetailState>(
      builder: (context, state) {
        // Eğer DetailInitial durumundaysa, detay bilgileri yüklemek için olay gönderir.
        if (state is DetailInitial) {
          context.read<DetailBloc>().add(FetchDetailId(id: widget.id));
          return const Center(child: CircularProgressIndicator());
        }
        // Eğer DetailLoading durumundaysa, bir yüklenme simgesi gösterir.
        if (state is DetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Eğer DetailLoaded durumundaysa, blog detaylarını gösterir.
        if (state is DetailLoaded) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.brown,
              title: Text(state.blogs.title!,
                  style: TextStyle(color: Colors.white)),
            ),
            // Blog detaylarını gösteren gövde bölümü.
            body: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Card(
                // Card widget'ı blog detaylarını stilize bir şekilde gösterir.
                elevation: 5,
                color: Color.fromARGB(255, 233, 232, 232),
                shadowColor: Colors.black.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Blog görselini gösterir.
                    AspectRatio(
                      aspectRatio: 4 / 2,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15.0)),
                        child: Image.network(
                          state.blogs.thumbnail!,
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    // Blog başlığını, yazarını ve içeriğini gösterir.
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.blogs.title!,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            state.blogs.author!,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            state.blogs.content!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // Eğer DetailError durumundaysa, bir hata mesajı gösterir.
        if (state is DetailError) {
          return const Center(
            child: Text("Hata Alındı",
                style:
                    TextStyle(fontWeight: FontWeight.w900, color: Colors.red)),
          );
        }
        // Eğer beklenmeyen bir durum varsa, genel bir mesaj gösterir.
        return const Center(
          child: Text("Veri Alınamadı",
              style:
                  TextStyle(fontWeight: FontWeight.w900, color: Colors.blue)),
        );
      },
    );
  }
}
