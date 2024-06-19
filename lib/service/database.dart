import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:notebook/model/model.dart';

class DataBaseService {
  final FirebaseFirestore _ref = FirebaseFirestore.instance;

  /// Kullanıcı kayıt etmek için ekleme
  Future<bool> newUser(Map<String, dynamic> data) async {
    try {
      return await _ref.collection('users').doc(data['id']).set(data).then((value) => true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Kullanıcı bilgilerini Firestore'dan getiriyor
  Future<Map<String, dynamic>?> findUserbyID(String userID) async {
    try {
      return await _ref.collection("users").doc(userID).get().then((userData) {
        return userData.data();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  /// Not getirme
  Future<NoteModel?> getNoteById(String userId, String noteId) async {
    try {
      DocumentSnapshot doc = await _ref.collection('users').doc(userId).collection('notes').doc(noteId).get();
      if (doc.exists) {
        return NoteModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  /// Tüm notları getirme
  Future<List<NoteModel>> getAllNotes(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _ref.collection('users').doc(userId).collection('notes').get();
      return querySnapshot.docs.map((doc) => NoteModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> addNote(String userId, NoteModel newNote) async {
    try {
      await _ref.collection('users').doc(userId).collection('notes').doc(newNote.id).set(newNote.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteNote(String userId, String noteId) async {
    try {
      await _ref.collection('users').doc(userId).collection('notes').doc(noteId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> updateNote(String userId, NoteModel noteToUpdate) async {
    try {
      await _ref.collection('users').doc(userId).collection('notes').doc(noteToUpdate.id).update(noteToUpdate.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<List<NoteModel>> getNotes(String userId) async {
    List<NoteModel> notes = await getAllNotes(userId);
    return notes;
  }
}