import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/screens/addNotes.dart';
import '../model/notes.dart';
import '../model/notes_details.dart';
import 'notesDetails.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Note> notes = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final response = await http.get(Uri.parse("http://192.168.100.37/fetch.php"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      setState(() {
        notes = list.map((model) => Note.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load notes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailsEdit(note: notes[index],),
                ),
              ).then((value) {
                // Refresh the notes list after returning from details/edit page
                if (value == true) {
                  fetchNotes();
                }
              });
            },

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NoteCreation()));
        },
        child: Text('Add'),
      ),
    );
  }
}
