import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/controller/app_theme.dart';
import 'package:silivri_havuz/customWidgets/screen_background.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import 'package:silivri_havuz/navigator/ui_page.dart';

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(Icons.pool, size: 80, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  "Silivri Havuz Hoş Geldiniz",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),

                // Email Field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Password Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Login Button
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  child: Ink(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: AppTheme.buttonPrimaryDecoration,
                    child: Text(
                      "Giriş yap",
                      style:
                          AppState.instance.themeData.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    CustomRouter.instance.replaceAll(ConfigHome);
                  },
                ),
                /*ElevatedButton(
                  onPressed: () {
                    CustomRouter.instance.replaceAll(ConfigHome);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppState.instance.themeData.primaryColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text("Giriş yap"),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
