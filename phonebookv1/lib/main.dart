import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp()); //responsible for running the app

class Todo {
  final String firstName;
  final String lastName;
  final List<dynamic> numbers;

  Todo(this.firstName, this.lastName, this.numbers);
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Phonebook';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {

  int numberOfContactNumbers = 1;
  List<Todo> todoContacts = <Todo>[];
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  List<TextEditingController> contactNumberControllers =
      <TextEditingController>[TextEditingController()];
  //Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter First Name',
          ),
          keyboardType: TextInputType.name,
          controller: firstNameController,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Last Name',
          ),
          keyboardType: TextInputType.name,
          controller: lastNameController,
        ),
        Flexible(
          child: ListView.builder(
              itemCount: numberOfContactNumbers,
              itemBuilder: (context, index) {
                return ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter number',
                    ),
                    keyboardType: TextInputType.number,
                    controller: contactNumberControllers[index],
                  ),
                );
              }),
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    numberOfContactNumbers++;
                    contactNumberControllers.insert(0, TextEditingController());
                  });
                },
                child: Icon(Icons.person_add)),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (numberOfContactNumbers != 0) {
                      numberOfContactNumbers--;
                      contactNumberControllers.removeAt(0);
                    }
                  });
                },
                child: Icon(Icons.person_remove)),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              List<dynamic> numbers = <dynamic>[];
              for (int i = 0; i < numberOfContactNumbers; i++) {
                numbers.insert(0, contactNumberControllers[i].text);
              }
              setState(() {
                todoContacts.insert(
                    0,
                    Todo(firstNameController.text, lastNameController.text,
                        numbers));
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContactRoute(
                        contacts: todoContacts,
                      )));
            },
            child: Icon(Icons.add_comment)),
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => ContactRoute(
        //                     contacts: todoContacts,
        //                   )));
        //     },
        //     child: Text('Add'))

      ],
    );
  }


}

class ContactRoute extends StatelessWidget {
  final List<Todo> contacts;

  const ContactRoute({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saves Contacts'),
        ),
        body: Center(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${contacts[index].firstName} ${contacts[index].lastName}'),subtitle: Text('${contacts[index].numbers}'),
                        );
                      }),
                ),
                DisplayContacts(),
              ],
            )
        )
    );
  }
}

//
// API post the file
//


class DisplayContacts extends StatefulWidget {
  const DisplayContacts({Key? key}) : super(key: key);

  @override
  _DisplayContactsState createState() => _DisplayContactsState();
}

class _DisplayContactsState extends State<DisplayContacts> {
  List<Future<Album>> contactsFromDatabase = [];
  late List<Future<Album>> contactsFromDB;
  int numberOfDocuments = 0;

  getNumberOfDocuments() async {
    final request = await http.get(Uri.parse('http://10.0.0.39:3000/contacts/N'));
    return request.body;
  }

  Future<Album> createAlbum(String firstName, String lastName, List<dynamic> numbers) async {
    final response = await http.post(
      Uri.parse('http://10.0.0.39:3000/contacts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'FirstName' : firstName,
        'lastName' : lastName,
        'numbers' : numbers,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }



//
// get the file
//
  Future<Album> fetchAlbum(int index) async {
  final response =
  await http.get(Uri.parse('http://10.0.0.39:3000/contacts'));

  if (response.statusCode == 200) {
  // If the server did return a 200 OK response,
  // then parse the JSON.
  return Album.fromJson(jsonDecode(response.body[index]));
  } else {
  // If the server did not return a 200 OK response,
  // then throw an exception.
  throw Exception('Failed to load album');
  }
  }
  @override
  void initState() {
    super.initState();
    getNumberOfDocuments().then((val) {
      setState(() {
        numberOfDocuments = int.parse(val);
        for (int i = 0; i < numberOfDocuments; i++) {
          contactsFromDatabase.insert(i, fetchAlbum(i));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(itemCount: numberOfDocuments,itemBuilder: (context, index) {
        return ListTile(
          title: FutureBuilder<Album>(
            future: contactsFromDatabase[index],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('index' );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return CircularProgressIndicator();
            },
          ),
        );
      }),
    );
  }
}

class Album {
  final String lastName;
  final String firstName;
  List<dynamic> phoneNumbers;

  Album({required this.lastName, required this.firstName, required this.phoneNumbers});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        lastName: json['last_name'],
        firstName: json['first_name'],
        phoneNumbers: json['phone_numbers']
    );
  }
}