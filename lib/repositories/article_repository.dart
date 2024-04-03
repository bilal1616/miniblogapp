import 'dart:convert';

// Resim seçme işlemi için image_picker paketini içe aktarır.
import 'package:image_picker/image_picker.dart';
// Blog verilerini temsil eden Blog modelini içe aktarır.
import 'package:miniblogapp/models/blog.dart';
// HTTP istekleri göndermek için http paketini içe aktarır.
import 'package:http/http.dart' as http;

// ArticleRepository adında bir sınıf tanımlar.
class ArticleRepository {
  // Tüm blogları almak için bir HTTP GET isteği gönderen metod.
  Future<List<Blog>> fetchAllBlogs() async {
    // API'nin URL'sini oluşturur.
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    // HTTP GET isteği gönderir ve yanıtı bekler.
    final response = await http.get(url);
    // Yanıttan JSON verisini çözümleyerek bir liste oluşturur ve döndürür.
    final List jsonData = json.decode(response.body);
    return jsonData.map((json) => Blog.fromJson(json)).toList();
  }

  // Belirli bir blogu almak için bir HTTP GET isteği gönderen metod.
  Future<Blog> fetchBlogId(String id) async {
    // API'nin URL'sini oluşturur.
    Uri url =
        Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles/${id}");
    // HTTP GET isteği gönderir ve yanıtı bekler.
    final response = await http.get(url);
    // Yanıttan JSON verisini çözümleyerek bir Blog nesnesi oluşturur ve döndürür.
    final jsonData = json.decode(response.body);
    return Blog.fromJson(jsonData);
  }

  // Bir blog eklemek için bir HTTP POST isteği gönderen metod.
  Future<void> addBlog(String title, String content, String author, XFile? image) async {
    // API'nin URL'sini oluşturur.
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    // HTTP POST isteği için bir MultipartRequest oluşturur.
    var request = http.MultipartRequest("POST", url);

    // İsteğin alanlarını doldurur.
    request.fields['Title'] = title;
    request.fields['Content'] = content;
    request.fields['Author'] = author;
    if (image != null) {
      // Eğer bir resim seçildiyse, resmi isteğe ekler.
      request.files.add(await http.MultipartFile.fromPath("File", image.path));
    }

    // İsteği gönderir ve yanıtı bekler.
    var response = await request.send();
    // Yanıtın durum kodunu kontrol ederek hata olup olmadığını kontrol eder.
    if (response.statusCode != 201) {
      throw Exception('Blog eklenemedi');
    }
  }
}
