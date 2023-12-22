class Blog {
  String? id;
  String? title;
  String? content;
  String? thumbnail;
  String? author;

  // Blog sınıfının constructor'ı. 
  Blog({this.id, this.title, this.content, this.thumbnail, this.author});

  // JSON verisinden Blog nesnesini oluşturan constructor.
  Blog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    author = json['author'];
  }

  // Blog nesnesini JSON formatına çeviren metod.
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
