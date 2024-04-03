// Flutter'ın temel malzeme tasarım widget'larını içe aktarır.
import 'package:flutter/material.dart';
// flutter_bloc paketini içe aktarır, BLoC mimarisini kullanım için gerekli.
import 'package:flutter_bloc/flutter_bloc.dart';
// Uygulamadaki özel bloc'ları içe aktarır.
import 'package:miniblogapp/blocs/article_bloc/article_bloc.dart';
import 'package:miniblogapp/blocs/detail_bloc/detail_bloc.dart';
// Makalelerle ilgili işlemleri yöneten repository'yi içe aktarır.
import 'package:miniblogapp/repositories/article_repository.dart';
// Uygulamanın ana sayfasını içe aktarır.
import 'package:miniblogapp/screens/homepage.dart';

// Uygulamanın ana giriş fonksiyonu.
void main() {
  // Flutter uygulamasını başlatır.
  runApp(MultiBlocProvider(
    providers: [
      // ArticleBloc'u sağlar, Makale işlemleri için kullanılır.
      BlocProvider<ArticleBloc>(
        create: (context) =>
            ArticleBloc(articleRepository: ArticleRepository()),
      ),
      // DetailBloc'u sağlar, Makale detayları için kullanılır.
      BlocProvider<DetailBloc>(
        create: (context) => DetailBloc(articleRepository: ArticleRepository()),
      )
    ],
    // MaterialApp widget'ını başlatır, uygulamanın görsel yapısını oluşturur.
    child: const MaterialApp(
      // Debug etiketini kapatır.
      debugShowCheckedModeBanner: false,
      // Uygulamanın ana sayfası olarak Homepage widget'ını kullanır.
      home: Homepage(),
    ),
  ));
}
