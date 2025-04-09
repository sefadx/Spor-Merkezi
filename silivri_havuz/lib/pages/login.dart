import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/controller/app_theme.dart';
import 'package:silivri_havuz/customWidgets/screen_background.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import 'package:silivri_havuz/navigator/ui_page.dart';
import 'package:silivri_havuz/network/api.dart';
import 'package:silivri_havuz/pages/table.dart';

import '../controller/provider.dart';
import '../model/trainer_model.dart';

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
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
                        const Text(
                          "T.C. Silivri Belediyesi Sosyal Tesis Yönetim Yazılımı \nHoş Geldiniz",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Email Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'E-posta',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Password Field
                        TextField(obscureText: true, decoration: InputDecoration(labelText: 'Şifre', border: OutlineInputBorder())),
                        SizedBox(height: 16),

                        // Login Button
                        InkWell(
                            borderRadius: BorderRadius.circular(8),
                            child: Ink(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppTheme.gapsmall),
                                decoration: AppTheme.buttonPrimaryDecoration(context),
                                child: Text("Giriş yap", style: appState.themeData.textTheme.headlineSmall, textAlign: TextAlign.center)),
                            onTap: () async {
                              /*BaseResponseModel res = await APIService(url: APIS.api.login()).post(ListWrapped.fromJson(
                      jsonList: [],
                      fromJsonT: (p0) => MemberModel.fromJson(json: {}),
                    ));*/
                              //CustomRouter.instance.replacePushWidget(child: PageTable(), pageConfig: ConfigHome);
                              CustomRouter.instance.replaceAll(ConfigHome);
                            })
                      ],
                    )))));
  }
}
