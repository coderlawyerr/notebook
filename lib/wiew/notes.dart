import 'package:flutter/material.dart';


import 'dart:math';

import 'package:notebook/const/const.dart';
import 'package:notebook/model/model.dart';
import 'package:notebook/service/database.dart';
import 'package:notebook/wiew/settings.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();

  Color getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();
  final DataBaseService _dbService = DataBaseService();
  final String userId = 'notes';
  List<NoteModel> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    List<NoteModel> notes = await _dbService.getNotes(userId);
    setState(() {
      _notes = notes;
    });
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Not Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'Başlık',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Notunuzu buraya yazın...',
                ),
                maxLines: null,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String title = _titleTextEditingController.text;
                String noteText = _textEditingController.text;
                if (title.isNotEmpty && noteText.isNotEmpty) {
                  await _addNewNote(title, noteText);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Ekle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNewNote(String title, String noteText) async {
    NoteModel newNote = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: noteText,
      updatedTime: DateTime.now(),
    );
    bool result = await _dbService.addNote(userId, newNote);
    if (result) {
      setState(() {
        _notes.add(newNote);
      });
    }
  }

  Future<void> _deleteNote(String noteId) async {
    bool result = await _dbService.deleteNote(userId, noteId);
    if (result) {
      setState(() {
        _notes.removeWhere((note) => note.id == noteId);
      });
    }
  }

  Future<void> _updateNoteContent(String noteId, String newContent) async {
    int index = _notes.indexWhere((note) => note.id == noteId);
    NoteModel noteToUpdate = _notes[index];

    noteToUpdate.content = newContent;
    noteToUpdate.updatedTime = DateTime.now();

    bool result = await _dbService.updateNote(
      userId,
      noteToUpdate,
    ); // Firebase'de notu güncelle

    if (result) {
      setState(() {
        _notes[index] = noteToUpdate; // Başarılı ise listeyi güncelle
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Search notes",
                hintStyle: const TextStyle(color: Colors.pink),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                fillColor: Colors.grey,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (BuildContext context, int index) {
                  NoteModel note = _notes[index];
                  return GestureDetector(
                    onTap: () {
                      _showNoteDetailPage(note);
                    },
                    child: Card(
                      color: widget.getRandomColor(),
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: const TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        subtitle: Text(
                          "Edited: ${note.updatedTime.day}/${note.updatedTime.month}/${note.updatedTime.year}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await _deleteNote(note.id);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            IconButton(
                              onPressed: () {
                                _showEditNoteDialog(note);
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  void _showEditNoteDialog(NoteModel note) {
    TextEditingController _titleEditController =
        TextEditingController(text: note.title);
    TextEditingController _editTextController =
        TextEditingController(text: note.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleEditController,
                decoration: const InputDecoration(
                  hintText: 'Başlık',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _editTextController,
                decoration: const InputDecoration(
                  hintText: 'Notunuzu buraya yazın...',
                ),
                maxLines: null,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String newTitle = _titleEditController.text;
                String newContent = _editTextController.text;
                if (newTitle.isNotEmpty && newContent.isNotEmpty) {
                  await _updateNoteContent(note.id, newContent);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteDetailPage(NoteModel note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final NoteModel note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              note.content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Edited: ${note.updatedTime.day}/${note.updatedTime.month}/${note.updatedTime.year}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}