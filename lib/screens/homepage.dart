// Flutter'ın malzeme tasarımı widget'larını ve diğer temel özelliklerini içe aktarır.
import 'package:flutter/material.dart';
// flutter_bloc paketini içe aktarır, BLoC mimarisini kullanım için gerekli.
import 'package:flutter_bloc/flutter_bloc.dart';
// Uygulamanın ArticleBloc'unu ve ilgili olayları ve durumları içe aktarır.
import 'package:miniblogapp/blocs/article_bloc/article_bloc.dart';
import 'package:miniblogapp/blocs/article_bloc/article_event.dart';
import 'package:miniblogapp/blocs/article_bloc/article_state.dart';
// Blog modelini içe aktarır.
import 'package:miniblogapp/models/blog.dart';
// Blog ekleme ekranını içe aktarır.
import 'package:miniblogapp/screens/add_blog.dart';
// Blog öğesi widget'ını içe aktarır.
import 'package:miniblogapp/widgets/blog_item.dart';

// Stateful widget olarak Homepage sınıfını tanımlar. Dinamik özelliklere sahip olacak.
class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

// Homepage için state sınıfı.
class _HomepageState extends State<Homepage> {
  // ScrollController, sayfadaki kaydırma işlemleri için kullanılır.
  final ScrollController _scrollController = ScrollController();
  // Blog listesi.
  List<Blog> blogs = [];

  @override
  void initState() {
    super.initState();
    // initState, widget oluşturulduğunda çalışan ilk metottur.
  }

  // Sayfanın en üstüne kaydırmak için yardımcı metod.
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceOut,
    );
  }

  // Widget'ın görsel yapısını oluşturan build metodunu tanımlar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Blog Sayfası",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // AppBar'da bulunan eylemler.
        actions: [
          IconButton(
            onPressed: () async {
              // Yeni blog ekleme sayfasına yönlendirme ve sonucunu kontrol etme.
              bool? result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => AddBlog()),
              );
              // Yeni blog eklendiğinde, makaleleri yeniden yükleme.
              if (result == true) {
                context.read<ArticleBloc>().add(FetchArticles());
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      // Uygulamanın ana içeriği.
      body: Center(
        child: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) {
            // Duruma göre farklı görünümler sunar.
            if (state is ArticlesInitial) {
              // İlk durumda, makaleleri yüklemek için olay gönderir.
              context.read<ArticleBloc>().add(FetchArticles());
              return const Center(
                child: Text("İstek atılıyor..."),
              );
            }

            if (state is ArticlesLoading) {
              // Makaleler yüklenirken dönen bir yüklenme simgesi gösterir.
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ArticlesLoaded) {
              // Makaleler yüklendiğinde, bir liste görünümü sunar.
              return RefreshIndicator(
                onRefresh: () async {
                  // Yenileme işlemi için olay gönderir.
                  context.read<ArticleBloc>().add(FetchArticles());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.blogs.length,
                  itemBuilder: (context, index) =>
                      BlogItem(blog: state.blogs[index]),
                ),
              );
            }

            if (state is ArticlesError) {
              // Hata durumunda bir hata mesajı gösterir.
              return const Center(
                child: Text("Bloc'lar yüklenirken hata oluştu."),
              );
            }

            // Tanımlanmamış durumlar için genel bir metin.
            return const Center(
              child: Text("Unknow State"),
            );
          },
        ),
      ),
      // Sayfanın en üstüne kaydırmak için bir buton.
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 110, 110, 110),
      ),
    );
  }
}
