import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/model/notes.dart';

class NoteEdit extends StatefulWidget {
  final String noteId;

  NoteEdit({required this.noteId, required Note note});

  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();



  @override
  void initState() {
    super.initState();
    // Fetch the note details when the screen is loaded
    fetchNoteDetails();
  }

  Future<void> fetchNoteDetails() async {
    final response = await http.get(
      Uri.parse("http://192.168.100.37/fetch_notes.php?id=${widget.noteId}"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        titleController.text = data['title'];
        contentController.text = data['content'];
      });
    } else {
      // Handle error
      print('Failed to fetch note details');
    }
  }

  Future<void> updateNote() async {
    final response = await http.post(
      Uri.parse("http://192.168.100.37/update_note.php"),
      body: {
        'id': widget.noteId,
        'title': titleController.text,
        'content': contentController.text,
      },
    );

    if (response.statusCode == 200) {
      // Note updated successfully
      Navigator.pop(context, true); // Return to the previous screen
    } else {
      // Handle error
      print('Failed to update note');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
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
              onPressed: updateNote,
              child: Text('Save Changes'),
            ),

          ],
        ),
      ),
    );
  }
}
