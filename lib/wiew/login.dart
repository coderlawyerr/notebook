// entrance.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notebook/service/authservice.dart';

import 'package:notebook/widgets/custombutton.dart';
import 'package:notebook/widgets/textfield.dart';
import 'package:notebook/wiew/notes.dart';
import 'package:notebook/wiew/register.dart';

class Entrance extends StatelessWidget {
  AuthService authService = AuthService();
  Entrance({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 191, 182),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fox.png"),
              fit: BoxFit.cover, // Resmin tüm alanı kaplaması için
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 150, right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "GİZLİ NOTLAR",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                CustomTextField(
                  controller: usernameController,
                  labelText: "Kullanıcı Adı",
                  hintText: "Kullanıcı adınızı giriniz",
                  borderRadius: BorderRadius.circular(15),
                  width: '20',
                ),
                SizedBox(height: 30),
                CustomTextField(
                  controller: passwordController,
                  labelText: "Şifre",
                  hintText: "Şifrenizi giriniz",
                  borderRadius: BorderRadius.circular(15),
                  width: '20',
                ),
                SizedBox(height: 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: " GİRİŞ YAP",
                      toDo: () async {
                        if (usernameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          // AuthService sınıfından signIn metodu kullanılarak kullanıcı girişi yapılır ve dönen kullanıcı kimliği (userid) alınır.
                          await authService
                              .signIn(usernameController.text,
                                  passwordController.text)
                              .then((userid) {
                            // Eğer kullanıcı kimliği null değilse, yani giriş başarılı olduysa
                            if (userid != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Hoş geldiniz!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Yeni sayfaya geçiş için Navigator kullanılarak mevcut sayfa yerine Overview sayfası geçilir.
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotesPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Giriş başarısız. Lütfen tekrar deneyin.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        } else
                          // Eğer e-posta veya şifre alanları boşsa, "Boş" mesajı konsola yazdırılır.
                          print("Boş");
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    CustomButton(
                        text: "KAYIT OL",
                        toDo: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Register(),
                              ));
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
