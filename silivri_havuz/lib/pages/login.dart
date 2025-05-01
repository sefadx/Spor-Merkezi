import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/controller/app_theme.dart';
import 'package:silivri_havuz/customWidgets/screen_background.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import 'package:silivri_havuz/navigator/ui_page.dart';
import 'package:silivri_havuz/network/api.dart';
import 'package:silivri_havuz/view_model/home.dart';

import '../controller/provider.dart';
import '../customWidgets/custom_label_textfield.dart';
import 'info_popup.dart';

class PageLogin extends StatelessWidget {
  PageLogin({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return ScreenBackground(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo
                            const Icon(Icons.pool, size: 80, color: Colors.white),
                            const SizedBox(height: 16),
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
                            Row(children: [
                              Expanded(child: SizedBox()),
                              Expanded(
                                  child: CustomLabelTextField(
                                controller: username,
                                label: "Kullanıcı Adı",
                                validator: (value) => value == null || value.isEmpty ? 'Kullanıcı adı giriniz' : null,
                              )),
                              Expanded(child: SizedBox()),
                            ]),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(child: SizedBox()),
                                Expanded(
                                  child: CustomLabelTextField(
                                    passwordVisible: true,
                                    controller: password,
                                    label: "Şifre",
                                    validator: (value) => value == null || value.isEmpty ? 'Şifre giriniz' : null,
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                            // Password Field

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(child: SizedBox()),
                                Expanded(
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Ink(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(AppTheme.gapsmall),
                                          decoration: AppTheme.buttonPrimaryDecoration(context),
                                          child: Text("Giriş yap", style: appState.themeData.textTheme.headlineSmall, textAlign: TextAlign.center)),
                                      onTap: () async {
                                        if (formKey.currentState!.validate()) {
                                          BaseResponseModel res =
                                              await APIService(url: APIS.api.login()).post(Auth(username: username.text, password: password.text)).onError((error, stackTrace) {
                                            debugPrint(error.toString());
                                            return BaseResponseModel(success: false, message: error.toString());
                                          });
                                          //CustomRouter.instance.replacePushWidget(child: PageTable(), pageConfig: ConfigHome);
                                          if (res.success) {
                                            ViewModelHome.instance.tc = username.text;
                                            CustomRouter.instance.replaceAll(ConfigHome);
                                          } else {
                                            CustomRouter.instance
                                                .pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
                                          }
                                        }
                                      }),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                            // Login Button
                          ],
                        ))))));
  }
}

class Auth implements JsonProtocol {
  Auth({required this.username, required this.password});
  String username;
  String password;

  factory Auth.fromJson({required Map<String, dynamic> json}) {
    try {
      return Auth(username: json["username"], password: json["password"]);
    } catch (err) {
      debugPrint("Subscription fromJson: $err");
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {"username": username.toString(), "password": password};
  }
}
