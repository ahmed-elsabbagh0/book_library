import 'package:books/BookModel/book_model.dart';
import 'package:books/Database/database_helper.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Book> _books = [];
  List<Book> _originalBooks = [];

  final controller = TextEditingController();

  Future<void> _retrieveBooks() async {
    List<Map<String, dynamic>> books =
    await DatabaseHelper.instance.retrieveBooks();
    setState(() {
      _originalBooks = books.map((e) => Book.fromMap(e)).toList();
      _books = List.from(_originalBooks);
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveBooks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _books = List.from(_originalBooks);
                    } else {
                      _books = _originalBooks
                          .where((element) =>
                          element.title.toLowerCase().contains(value))
                          .toList();
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Books",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
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
                        subtitle: Text('${_books[index].author} \nShelf Number: ${_books[index].shelf}'),
                        onTap: () {

                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            _deleteBook(_books[index].id!);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _retrieveBooks();
  }
}

