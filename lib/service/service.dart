import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  //NOT EKLEME

  Future<void> addNote(
      String title, String content, DateTime updatedTime) async {
    await _notesCollection.add({
      'title': title,
      'content': content,
      'updated': updatedTime,
    });
  }

  ////NOT GUNCELLEME
  Future<void> updateNote(
      String id, title, String content, DateTime updatedTime) async {
    await _notesCollection.doc(id).update({
      'title': title,
      'content': content,
      'updatedTime': updatedTime,
    });
  }

  /////NOT SİLME
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  //
}