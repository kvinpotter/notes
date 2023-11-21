import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/screens/home.dart';

class NoteCreation extends StatefulWidget {
  @override
  _NoteCreationState createState() => _NoteCreationState();
}

class _NoteCreationState extends State<NoteCreation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> createNote() async {
    final response = await http.post(
      Uri.parse("http://192.168.80.243/add_notes.php"),
      body: {
        'title': titleController.text,
        'content': contentController.text,
      },
    );

    if (response.statusCode == 200) {
      // Note created successfully
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home())); // Return to the previous screen
    } else {
      // Handle error
      print('Failed to create note');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createNote,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
