import 'package:flutter/material.dart';
import '../model/notes.dart';
import '../screens/edit notes.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteDetailsEdit extends StatelessWidget {
  final Note note;

  NoteDetailsEdit({required this.note});

  Future<void> _deleteNote(BuildContext context, String noteId) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.100.37/delete_notes.php"),
        body: {'id': noteId},
      );

      if (response.statusCode == 200) {
        // Note deleted successfully
        Navigator.pop(context, true); // Return to the previous screen
      } else {
        // Handle error
        print('Failed to delete note. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Network error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEdit(note: note, noteId: note.id),
                ),
              ).then((value) {
                // Refresh the notes list after returning from edit page
                if (value == true) {
                  Navigator.pop(context, true);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Note'),
                    content: Text('Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the delete function
                          _deleteNote(context, note.id);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              note.content,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
