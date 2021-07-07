import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Phonebook'),
    );
  }
}
class MainScreen extends StatelessWidget {
  final String title;
  MainScreen({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text (title),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder:
                    (context) => MyHomePage(title: 'Phonebook',)),
              );
            },
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phonebook"),
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Name'),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter Name",
                    labelText: "Firstname",
                    labelStyle: TextStyle(
                        fontSize: 25
                    )
                ),
                keyboardType: TextInputType.name,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter Name",
                    labelText: "Last Name",
                    labelStyle: TextStyle(
                        fontSize: 25
                    )
                ),
                keyboardType: TextInputType.name,
              ),
              Text(
                  "Contacts"),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter phone number",
                    labelText: "PhoneNumber",
                    labelStyle: TextStyle(
                        fontSize: 25
                    )
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        )

      ),
    );
  }
}

class DynamicWidget extends StatelessWidget {
  const DynamicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Number',
                labelText: 'Contact Number',
              ),
            )
          ],
        ),
      ),
    );
  }
}
class ContactsNumber extends StatefulWidget {
  const ContactsNumber({Key? key}) : super(key: key);

  @override
  _ContactsNumberState createState() => _ContactsNumberState();
}

class _ContactsNumberState extends State<ContactsNumber> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




