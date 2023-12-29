import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddBlog extends StatefulWidget {
  // AddBlog widget'ını oluştururken kullanılacak constructor.
  const AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  // Formun durumunu kontrol etmek için bir anahtar.
  final _formKey = GlobalKey<FormState>();
  
  // Resim seçme işlemleri için kullanılacak ImagePicker nesnesi.
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  // Blogun başlık, içerik ve yazar bilgilerini tutan değişkenler.
  String title = '';
  String content = '';
  String author = '';

  // Resim seçim işlemi.
  openImagePicker(ImageSource source) async {
    XFile? selectedFile = await _picker.pickImage(source: source);

    setState(() {
      selectedImage = selectedFile;
    });
  }

  // Formu gönderme işlemi.
  submitForm() async {
    // API endpoint'i.
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    var request = http.MultipartRequest("POST", url);

    // Seçilen resmi isteğe ekleyin.
    if (selectedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath("File", selectedImage!.path));
    }

    // Form verilerini isteğe ekleyin.
    request.fields['Title'] = title;
    request.fields['Content'] = content;
    request.fields['Author'] = author;

    // İsteği gönderin ve yanıtı kontrol edin.
    final response = await request.send();

    if (response.statusCode == 201) {
      // Başarıyla gönderildiyse, AddBlog ekranını kapatın ve ana ekrana dönün.
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Yeni Blog Ekle"),
      ),
      body: Padding(
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
                    onPressed: () {
                      openImagePicker(ImageSource.gallery); // Galeriden seç
                    },
                    child: Text("Galeriden Seç"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      openImagePicker(ImageSource.camera); // Kameradan seç
                    },
                    child: Text("Kameradan Seç"),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Blog Başlığı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen Başlık Giriniz";
                  }
                  return null;
                },
                onSaved: (newValue) => title = newValue!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Blog İçeriği"),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen İçerik Giriniz";
                  }
                  return null;
                },
                onSaved: (newValue) => content = newValue!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Ad Soyad"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen Ad Soyad Giriniz";
                  }
                  return null;
                },
                onSaved: (newValue) => author = newValue!,
              ),
              ElevatedButton(
                onPressed: () {
                  // Formun geçerliliğini kontrol et.
                  if (_formKey.currentState!.validate()) {
                    // Resim seçilmediyse hata göster.
                    if (selectedImage == null) {
                      // Hata göster..
                      return;
                    }
                    // Geçerliyse formu kaydet ve gönder.
                    _formKey.currentState!.save();
                    submitForm();
                  }
                },
                child: Text("Gönder"),
              )
            ],
          ),
        ),
      ),
    );
  }
}