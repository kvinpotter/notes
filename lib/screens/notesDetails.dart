import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/model/notes.dart';

class NoteDetails extends StatefulWidget {
  final String noteId;

  NoteDetails({required this.noteId, required Note note});


  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  late String title;
  late String content;

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
        title = data['title'];
        content = data['content'];
      });
    } else {
      // Handle error
      print('Failed to fetch note details');
    }
  }

  Future<void> deleteNote() async {
    final response = await http.post(
      Uri.parse("http://192.168.100.37/delete_note.php"),
      body: {
        'id': widget.noteId,
      },
    );

    if (response.statusCode == 200) {
      // Note deleted successfully
      Navigator.pop(context, true); // Return to the previous screen
    } else {
      // Handle error
      print('Failed to delete note');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                deleteNote();
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
