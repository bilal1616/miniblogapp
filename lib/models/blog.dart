// Blog adında bir sınıf tanımlar.
class Blog {
  // Blogun benzersiz kimliği.
  String? id;
  // Blogun başlığı.
  String? title;
  // Blogun içeriği.
  String? content;
  // Blogun küçük resmi (thumbnail).
  String? thumbnail;
  // Blogun yazarı.
  String? author;

  // Blog sınıfının yapılandırıcı metodudur.
  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.author,
  });

  // JSON verisini kullanarak Blog nesnesi oluşturmak için bir fabrika metodu.
  Blog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    author = json['author'];
  }

  // Blog nesnesini JSON verisine dönüştürmek için bir metod.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['thumbnail'] = this.thumbnail;
    data['author'] = this.author;
    return data;
  }
}
