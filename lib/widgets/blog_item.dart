// Flutter'ın malzeme tasarımı widget'larını içe aktarır.
import 'package:flutter/material.dart';
// flutter_bloc paketini içe aktarır, BLoC mimarisini kullanım için gerekli.
import 'package:flutter_bloc/flutter_bloc.dart';
// DetailBloc ve ilgili event'ları içe aktarır, detay işlemleri için kullanılır.
import 'package:miniblogapp/blocs/detail_bloc/detail_event.dart';
import 'package:miniblogapp/blocs/detail_bloc/detail_bloc.dart';
// Blog modelini içe aktarır, Blog veri yapısını tanımlar.
import 'package:miniblogapp/models/blog.dart';
// Blog detay sayfası widget'ını içe aktarır.
import 'package:miniblogapp/screens/blog_details.dart';

// BlogItem adında bir StatelessWidget tanımlar. Bu widget, bir blog maddesini temsil eder.
class BlogItem extends StatelessWidget {
  // Constructor (Yapıcı), gerekli parametrelerin geçilmesini sağlar.
  const BlogItem({super.key, required this.blog});

  // Blog tipinde bir değişken tanımlar, bu widget'a geçilen blog verisini tutar.
  final Blog blog;

  // Widget'ın görsel yapısını oluşturan build metodunu tanımlar.
  @override
  Widget build(BuildContext context) {
    // InkWell widget'ı, tıklanabilir bir alan oluşturur.
    return InkWell(
      onTap: () {
        // Tıklama olayında, DetailBloc içindeki ResetEvent'i tetikler ve detay sayfasına yönlendirir.
        context.read<DetailBloc>().add(ResetEvent());
        Navigator.push(
          context,
          MaterialPageRoute(
            // BlogDetails sayfasına, blog'un ID'si ile yönlendirir.
            builder: (context) => BlogDetails(id: blog.id!),
          ),
        );
      },
      // Card widget'ı, görsel olarak blog maddesini temsil eder.
      child: Card(
        margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
        elevation: 5,
        color: Color.fromARGB(255, 233, 232, 232),
        shadowColor: Colors.black.withOpacity(0.8),
        // Column widget'ı, blog görseli ve metinlerini dikey olarak sıralar.
        child: Column(
          children: [
            // Blog'un görselini gösterir.
            AspectRatio(
                aspectRatio: 4 / 2, child: Image.network(blog.thumbnail!)),
            // ListTile widget'ı, blog başlığını ve yazarını gösterir.
            ListTile(
              title: Text(blog.title!),
              subtitle: Text(blog.author!),
            )
          ],
        ),
      ),
    );
  }
}
