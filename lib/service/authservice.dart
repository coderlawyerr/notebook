import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// AuthService sınıfı, kimlik doğrulama işlemlerini gerçekleştiren metotları içerir.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mevcut oturum açmış kullanıcıyı döndürür.
  User? getCurrentUser() => _auth.currentUser;

  // Kullanıcı giriş işlemi için e-posta ve şifre ile oturum açma işlemi gerçekleştirir.
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print('Error: Giriş işleminde hata!: $e');
      }
      return null;
    }
  }

  // E-posta ve şifreyle yeni bir kullanıcı hesabı oluşturma işlemi gerçekleştirir.
  Future<String?> signupWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print('Error: Kayıt işleminde hata!: $e');
      }
      return null;
    }
  }

  // Şifre sıfırlama işlemi için bir metod.
  Future<bool> passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error: Şifre sıfırlama işleminde hata!: $e');
      }
      return false;
    }
  }

  // Kullanıcının oturumunu sonlandırır.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}