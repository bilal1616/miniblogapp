import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogDetails extends StatefulWidget {
  // BlogDetails widget'ını oluştururken kullanılacak constructor.
  const BlogDetails({Key? key, required this.blogId}) : super(key: key);

  // Detayları gösterilecek blogun kimliği.
  final String blogId;

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  // Blog detaylarını çekmek için kullanılacak Future() nesne.
  late Future<Map<String, dynamic>> _blogDetails;

  @override
  void initState() {
    super.initState();
    // Blog detaylarını çekmek için asenkron fonksiyonu başlat.
    _blogDetails = fetchBlogDetails(widget.blogId);
  }

  // Belirtilen blogun detaylarını çeken asenkron fonksiyon.
  Future<Map<String, dynamic>> fetchBlogDetails(String id) async {
    // API'den belirtilen blogun detaylarını çekmek için HTTP isteği yapılır.
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Başarılı bir şekilde veri alındıysa, JSON verisini bir map(metodu) haline getir.
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      // Başarısız olursa, boş bir map(metodu) döndür.
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Blog Detayları"),
      ),
      body: FutureBuilder(
        //Bu widget,bir Future nesnesinin tamamlanmasını bekler,ardından bu nesnenin sonucuna göre bir widget oluşturur.
        // _blogDetails, bir olayın sonucunu temsil eden Future nesnesidir.
        future: _blogDetails,
        // FutureBuilder, bir olayın sonuçlarına göre bir widget inşa eder.
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          // İnşa edilecek widget'ın belirlenmesi ve oluşturulması.

          // Eğer olayın sonucu hala bekleniyorsa (waiting), bir dönüş ikonu göster.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Eğer olayda bir hata oluştuysa veya veri alınamadıysa, hata mesajını göster.
          else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Veri Alınamadı.."));
          }
          // Eğer olay başarıyla tamamlandıysa, UI'yı oluşturan fonksiyonu çağır.
          else {
            return buildBlogDetailsUI(snapshot.data!);
          }
        },
      ),
    );
  }

  // Blog detaylarını gösteren arayüzü oluşturan fonksiyon.
  Widget buildBlogDetailsUI(Map<String, dynamic> blogData) {
    // Oluşturulan bir Container widget'ı.
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.6,
      // Oluşturulan bir Card widget'ı.
      child: Card(
        color: const Color.fromARGB(255, 243, 243, 243),
        elevation: 5, // Yükseltme (gölgeleme) seviyesi. 1 En düşük 5 En yüksek
        shape: RoundedRectangleBorder(
          // Border ayarları. Burada, kenarları yuvarlatılmış bir (borderRadius) kullanılıyor.
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blog resmini gösteren kısım.
            ClipRRect(
              // Resmin köşelerini yuvarlatmak için kullanılır. Bu durumda yukarıdaki köşeler yuvarlatılır.
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              // Ağ üzerinden bir resmi gösteren widget. Image.network, bir URL'den resim alır.
              child: Image.network(
                blogData['thumbnail'] ?? '', // Blog verilerindeki resim URL'si (varsa)
                width: double.infinity, // Genişlik, ekrana sığacak şekilde genişletilir.
                height: 200, // Yükseklik, belirtilen değere sabitlenir.
                fit: BoxFit.contain, // Resmi içeriğe sığacak şekilde boyutlandırır.
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog başlığını gösteren kısım.
                  Text(
                    "Blog Başlığı: ${blogData['title']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  // Blog içeriğini gösteren kısım.
                  Text("Blog İçeriği: ${blogData['content']}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  // Blog yazarını gösteren kısım.
                  Text("Blog Yazarı: ${blogData['author']}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
