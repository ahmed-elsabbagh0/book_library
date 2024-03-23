import 'package:books/BookModel/book_model.dart';
import 'package:books/Database/database_helper.dart';
import 'package:books/Screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _retrieveBooks();
  }

  Future<void> _retrieveBooks() async {
    List<Map<String, dynamic>> books =
        await DatabaseHelper.instance.retrieveBooks();
    setState(() {
      _books = books.map((e) => Book.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Library'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: (_books.isNotEmpty)
          ? ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(_books[index].title),
                      subtitle: Text(
                          '${_books[index].author} \nShelf Number: ${_books[index].shelf}'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteBook(_books[index].id!);
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                "No Books Yet, Add Some",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _retrieveBooks();
  }

  Future<void> _showAddBookDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController shelfController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: shelfController,
                decoration: const InputDecoration(labelText: 'Shelf Num'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String title = titleController.text;
                String author = authorController.text;
                String shelf = shelfController.text;

                if (title.isNotEmpty && author.isNotEmpty && shelf.isNotEmpty) {
                  await _addBook(title, author, shelf);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addBook(String title, String author, String shelf) async {
    Map<String, dynamic> book = {
      'title': title,
      'author': author,
      'shelf': shelf
    };
    await DatabaseHelper.instance.insertBook(book);
    _retrieveBooks();
  }
}
