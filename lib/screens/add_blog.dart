// Dart dosyalarını işlemek için 'dart:io' paketini içe aktarır.
import 'dart:io';
// Flutter'ın malzeme tasarımı widget'larını ve diğer temel özelliklerini içe aktarır.
import 'package:flutter/material.dart';
// flutter_bloc paketini içe aktarır, BLoC mimarisini kullanım için gerekli.
import 'package:flutter_bloc/flutter_bloc.dart';
// Kullanıcının resim seçebilmesi için ImagePicker'ı içe aktarır.
import 'package:image_picker/image_picker.dart';
// Uygulamanın ArticleBloc'unu ve ilgili olayları ve durumları içe aktarır.
import 'package:miniblogapp/blocs/article_bloc/article_bloc.dart';
import 'package:miniblogapp/blocs/article_bloc/article_event.dart';
import 'package:miniblogapp/blocs/article_bloc/article_state.dart';

// AddBlog adında bir StatefulWidget tanımlar. Bu widget, blog eklemek için kullanılır.
class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

// AddBlog için state sınıfı.
class _AddBlogState extends State<AddBlog> {
  // Formun anahtarını tutan bir GlobalKey oluşturur.
  final _formKey = GlobalKey<FormState>();
  // Resim seçmek için kullanılan ImagePicker nesnesini oluşturur.
  final ImagePicker _picker = ImagePicker();
  // Seçilen resmi tutan bir XFile nesnesi.
  XFile? selectedImage;

  // Başlık, içerik ve yazar bilgilerini saklayan değişkenler.
  String title = '';
  String content = '';
  String author = '';

  // Resim seçme işlemini gerçekleştiren metod.
  void openImagePicker(ImageSource source) async {
    XFile? selectedFile = await _picker.pickImage(source: source);
    setState(() {
      selectedImage = selectedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Blog Ekle",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: BlocListener<ArticleBloc, ArticleState>(
        listener: (context, state) {
          // Blog başarıyla eklendiğinde, ekranı kapatır ve ana sayfaya döner.
          if (state is BlogAdded) {
            Navigator.of(context).pop(true);
          }
          // Blog ekleme sırasında bir hata oluştuğunda kullanıcıya bilgi verir.
          else if (state is BlogAddError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Blog ekleme hatası!')));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (selectedImage != null)
                  Image.file(
                    File(selectedImage!.path),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      onPressed: () => openImagePicker(ImageSource.gallery),
                      child: Text("Galeriden Seç",
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      onPressed: () => openImagePicker(ImageSource.camera),
                      child: Text("Kameradan Seç",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Blog Başlığı"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Lütfen Başlık Giriniz"
                      : null,
                  onSaved: (newValue) => title = newValue!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Blog İçeriği"),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? "Lütfen Blog İçeriği Giriniz"
                      : null,
                  onSaved: (newValue) => content = newValue!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Ad Soyad"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Lütfen Ad Soyad Giriniz"
                      : null,
                  onSaved: (newValue) => author = newValue!,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    // Formun doğrulamasını yapar ve verileri kaydeder.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // ArticleBloc ile blog eklemesi yapılır.
                      context.read<ArticleBloc>().add(AddBlogEvent(
                            title: title,
                            content: content,
                            author: author,
                            image: selectedImage,
                          ));
                    }
                  },
                  child: Text('Gönder', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
