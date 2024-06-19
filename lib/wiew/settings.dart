import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.nightlight_round),
                      Expanded(
                        child: Slider(
                          value: _isDarkMode ? 1 : 0,
                          onChanged: (value) {
                            setState(() {
                              _isDarkMode = value == 1;
                            });
                          },
                          min: 0,
                          max: 1,
                          divisions: 1,
                          label: _isDarkMode ? 'Açık' : 'Kapalı',
                        ),
                      ),
                      const Icon(Icons.sunny),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Kullanıcı Adını Değiştir'),
                  onTap: () {
                    // Kullanıcı adını değiştirme sayfasına git
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Şifreyi Değiştir'),
                  onTap: () {
                    // Şifreyi değiştirme sayfasına git
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('Dil Seçimi'),
                  onTap: () {
                    // Dil seçimi sayfasına git
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Arka Planı Değiştir'),
                  onTap: () {
                    // Arka planı değiştirme sayfasına git
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
