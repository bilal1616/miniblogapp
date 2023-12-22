import 'package:flutter/material.dart';
import 'package:miniblogapp/models/blog.dart';

class BlogItem extends StatelessWidget {
  // BlogItem widget'ını oluştururken kullanılacak constructor.
  const BlogItem({super.key, required this.blog});

  // Blog verilerini içeren nesne.
  final Blog blog;

  @override
  Widget build(BuildContext context) {
    // Kart oluşturulması ve kenar boşluklarının ayarlanması.
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Görsel öğeyi gösteren AspectRatio widget'ı.
            AspectRatio(
              aspectRatio: 4/2,
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                // Görselin ortalanmış bir versiyonu.
                child: Center(child: Image.network(blog.thumbnail!)),
              )
            ),
            // Başlık ve yazarı gösteren ListTile widget'ı.
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
