import 'package:flutter/material.dart';
import 'package:flutter_application_1/bookcontroller.dart';
import 'package:flutter_application_1/bookmodel.dart';
import 'package:flutter_application_1/modal.dart'; // Assuming you have a modal widget

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BookController bookController = BookController();
  final formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController photo = TextEditingController();
  List buttonChoice = ["Update", "Delete"];
  List? books;
  int? bookId;

  void getBooks() {
    setState(() {
      books = bookController.books; // Assuming `books` is the list in BookController
    });
  }

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                bookId = null; // Resetting the book ID for adding a new book
              });
              author.clear();
              photo.clear();
              description.clear();
              ModalWidget().showFullModal(context, addItem(null)); // Show modal for adding a new book
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image(image: AssetImage(books![index].photo)), // Assuming `photo` is a property
              title: Text(books![index].author), // Displaying author
              subtitle: Column(
                children: [Text(books![index].author),
                Text(books![index].description)],
              ) // Displaying description
              ,trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return buttonChoice.map((choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                      onTap: () {
                        if (choice == "Update") {
                          setState(() {
                            bookId = books![index].id; // Assuming `id` is a property
                          });
                          author.text = books![index].author;
                          photo.text = books![index].photo;
                          description.text = books![index].description;
                          ModalWidget().showFullModal(context, addItem(index)); // Show modal for updating
                        } else if (choice == "Delete") {
                          setState(() {
                            books!.removeAt(index); // Remove the book from the list
                            getBooks(); // Refresh the book list
                          });
                        }
                      },
                    );
                  }).toList();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addItem(int? index) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: author,
              decoration: InputDecoration(labelText: "Author"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Author must be filled';
                }
                return null;
              },
            ),
            TextFormField(
              controller: photo,
              decoration: InputDecoration(labelText: "Photo URL"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Photo must be filled';
                }
                return null;
              },
            ),
            TextFormField(
              controller: description,
              decoration: InputDecoration(labelText: "Description"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Description must be filled';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (index != null) {
                    // Update existing book
                    books![index].author = author.text;
                    books![index].photo = photo.text;
                    books![index].description = description.text;
                    books![index].stock = stock.text;
                  } else {
                    // Add new book
                    books!.add(BookModel(
                      id: books!.length + 1, // Assuming ID is auto-increment
                      author: author.text,
                      photo: photo.text,
                      description: description.text,
                      stock: stock.text,
                    ));
                  }
                  getBooks(); // Refresh the book list
                  Navigator.pop(context); // Close the modal
                }
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
