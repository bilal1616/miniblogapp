import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:miniblogapp/models/blog.dart';
import 'package:http/http.dart' as http;
import 'package:miniblogapp/screens/add_blog.dart';
import 'package:miniblogapp/screens/blog_details.dart';
import 'package:miniblogapp/widgets/blog_item.dart';

class Homepage extends StatefulWidget {
  // Homepage widget'ını oluştururken kullanılacak constructor.
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Blog verilerini içeren liste.
  List<Blog> blogs = [];

  @override
  void initState() {
    super.initState();
    // Sayfa başlatıldığında blog verilerini çeken fonksiyon.
    fetchBlogs();
  }

  // Blog verilerini API'den çekip listeye ekleyen fonksiyon.
  fetchBlogs() async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    final response = await http.get(url);
    final List jsonData = json.decode(response.body);

    setState(() {
      blogs = jsonData.map((json) => Blog.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Bloglar"),
        actions: [
          // Yeni blog eklemek için kullanılacak buton.
          IconButton(
            onPressed: () async {
              // AddBlog ekranına geçiş yapılır ve ekran kapatıldığında
              // dönen değer kontrol edilerek blog verileri yeniden çekilir.
              bool? result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => AddBlog()),
              );

              if (result == true) {
                fetchBlogs();
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: blogs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              // Ekranı aşağı çekildiğinde blog verilerini yeniden çekmek için kullanılır.
              onRefresh: () async {
                fetchBlogs();
              },
              child: ListView.builder(
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    // Tıklanan blogun detaylarını gösteren ekran açılır.
                    if (blogs[index].id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlogDetails(blogId: blogs[index].id!),
                        ),
                      );
                    }
                  },
                  child: BlogItem(blog: blogs[index]),
                ),
                itemCount: blogs.length,
              ),
            ),
    );
  }
}
