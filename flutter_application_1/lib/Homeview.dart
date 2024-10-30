import 'package:flutter/material.dart';
import 'package:flutter_application_1/bookcontroller.dart';
import 'package:flutter_application_1/bookmodel.dart';
import 'package:flutter_application_1/modal.dart'; 
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
  TextEditingController Name = TextEditingController();
  List buttonChoice = ["Update", "Delete"];
  List? books;
  int? bookId;

  void getBooks() {
    setState(() {
      books = bookController.books; 
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
                bookId = null; 
              });
              author.clear();
              Name.clear();
              photo.clear();
              description.clear();
              ModalWidget().showFullModal(context, addItem(null)); 
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
              leading: Image(image: AssetImage(books![index].photo)), 
              title: Text(books![index].Name), 
              subtitle: Column(
                children: [Text(books![index].author),
                Text(books![index].description),
                Text("Stock:"+books![index].stock)],
              ) 
              ,trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return buttonChoice.map((choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                      onTap: () {
                        if (choice == "Update") {
                          setState(() {
                            bookId = books![index].id; 
                          });
                          Name.text = books![index].author;
                          author.text = books![index].author;
                          photo.text = books![index].photo;
                          description.text = books![index].description;
                          ModalWidget().showFullModal(context, addItem(index)); 
                        } else if (choice == "Delete") {
                          setState(() {
                            books!.removeAt(index); 
                            getBooks(); 
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
              controller: Name,
              decoration: InputDecoration(labelText: "Title"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title must be filled';
                }
                return null;
              },
            ),
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
                   
                    books![index].author = author.text;
                    books![index].photo = photo.text;
                    books![index].description = description.text;
                    books![index].stock = stock.text;
                  } else {
                    
                    books!.add(BookModel(
                      Name: Name.text,
                      id: books!.length + 1, 
                      author: author.text,
                      photo: photo.text,
                      description: description.text,
                      stock: stock.text,
                    ));
                  }
                  getBooks(); 
                  Navigator.pop(context); 
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
