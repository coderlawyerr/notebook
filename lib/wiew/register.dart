import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:notebook/model/usermodel.dart';
import 'package:notebook/service/authservice.dart';
import 'package:notebook/service/database.dart';
import 'package:notebook/widgets/custombutton.dart';
import 'package:notebook/widgets/textfield.dart';
import 'package:notebook/wiew/login.dart';
import 'package:notebook/wiew/notes.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    BorderRadius borderRadius = BorderRadius.circular(20);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 191, 182),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Entrance()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "KAYIT OL",
              style: TextStyle(fontSize: 45, color: Colors.brown),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              width: "20",
              controller: usernameController,
              labelText: "Kullanıcı Adı",
              hintText: "Kullanıcı Adı",
              borderRadius: borderRadius,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              width: "20",
              controller: emailController,
              labelText: "E-posta",
              hintText: "E-posta",
              borderRadius: borderRadius,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              width: "20",
              controller: passwordController,
              labelText: "Şifre",
              hintText: "Şifre",
              borderRadius: borderRadius,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "KAYIT OL",
              toDo: () async {
                if (usernameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  // AuthService sınıfından bir örnek alınır
                  // Bu, kullanıcı girişi ve kaydı işlemlerini gerçekleştirmek için kullanılır
                  await AuthService()
                      .signupWithEmail(
                    emailController.text,
                    passwordController.text,
                  )
                      .then((userid) async {
                    // Kullanıcı kaydı başarılı bir şekilde tamamlandıysa devam edilir
                    if (userid != null) {
                      // Yeni bir UserModel örneği oluşturulur ve kullanıcı kimliği (userID) atanır
                      UserModel userdata = UserModel(
                        id: userid,
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      // Kullanıcı bilgileri UserModel'den bir haritaya dönüştürülür ve veritabanına eklenir
                      await DataBaseService().newUser(userdata.toMap());
                      // Kullanıcı kaydı başarılı bir şekilde tamamlandıktan sonra oturumu kapatır
                      AuthService().signOut();
                      // Kullanıcı giriş sayfasına yönlendirilir
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const NotesPage(),
                        ),
                      );
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}