class Book {
  int? id;
  String title;
  String author;
  String shelf;

  Book({this.id, required this.title, required this.author, required this.shelf});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'shelf': shelf};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      shelf: map['shelf'],
    );
  }
}
