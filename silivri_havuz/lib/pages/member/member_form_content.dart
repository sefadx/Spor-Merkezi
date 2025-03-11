import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../utils/enums.dart';
import '../../controller/app_state.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../view_model/member_details.dart';

class FormContentMember extends StatelessWidget {
  const FormContentMember({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelMemberDetails>(context);
    return Padding(
      padding: const EdgeInsets.all(AppTheme.gapmedium),
      child: Form(
        key: vm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Kişisel Bilgiler", style: appState.themeData.textTheme.headlineMedium),
              SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: CustomLabelTextField(readOnly: vm.readOnly, controller: vm.identityController, label: "T.C. Kimlik No"
                        //validator: validateIdentityNumber
                        )),
                SizedBox(width: 30),
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.nameController,
                        label: "Ad",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad gerekli';
                          }
                          return null;
                        })),
                SizedBox(width: 30),
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.surnameController,
                        label: "Soyad",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Soyad gerekli';
                          }
                          return null;
                        }))
              ]),
              SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.birthdateController,
                        label: "Doğum Tarihi   gg/aa/yyyy",
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color: appState.themeData.primaryColorDark,
                          ),
                          onPressed: !vm.readOnly
                              ? () async {
                                  vm.pickDate(context);
                                }
                              : null,
                        ))),
                SizedBox(width: 30),
                Expanded(
                    child: vm.readOnly
                        ? CustomLabelTextField(
                            readOnly: vm.readOnly,
                            controller: vm.birthPlaceController,
                            label: "Doğum Yeri",
                          )
                        : CustomDropdownList(
                            readOnly: vm.readOnly,
                            value: vm.birthPlaceController.text != "" ? vm.birthPlaceController.text : null,
                            labelText: "Doğum Yeri",
                            list: List<String>.from(Cities.values.map((e) => e.toString())),
                            errorText: 'Doğum yeri seçilmesi gerekiyor.',
                            onChanged: (text) {
                              vm.birthPlaceController.text = text!;
                            }))
              ]),
              SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: vm.readOnly
                        ? CustomLabelTextField(
                            readOnly: vm.readOnly,
                            controller: vm.genderController,
                            label: "Cinsiyet",
                          )
                        : CustomDropdownList(
                            readOnly: vm.readOnly,
                            value: vm.genderController.text != "" ? vm.genderController.text : null,
                            labelText: "Cinsiyet",
                            list: List<String>.from(Genders.values.map((e) => e.toString())),
                            errorText: 'Cinsiyet seçilmesi gerekiyor.',
                            onChanged: (text) {
                              vm.genderController.text = text!;
                            })),
                SizedBox(width: 30),
                Expanded(
                    child: vm.readOnly
                        ? CustomLabelTextField(
                            readOnly: vm.readOnly,
                            controller: vm.educationLevelController,
                            label: "Eğitim Durumu",
                          )
                        : CustomDropdownList(
                            readOnly: vm.readOnly,
                            value: vm.educationLevelController.text != "" ? vm.educationLevelController.text : null,
                            labelText: "Eğitim Durumu",
                            list: List<String>.from(EducationLevels.values.map((e) => e.toString())),
                            errorText: 'Eğitim durumunuzu seçiniz.',
                            onChanged: (text) {
                              vm.educationLevelController.text = text!;
                            })),
              ]),
            ]),
            SizedBox(height: 40),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("İletişim Bilgileri", style: appState.themeData.textTheme.headlineMedium),
              SizedBox(height: 10),
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.phoneController,
                        label: "Telefon Numarası",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Telefon numarası gerekli';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Geçerli bir telefon numarası girin';
                          }
                          return null;
                        })),
                SizedBox(width: 30),
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.emailController,
                        label: "E-posta",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta adresi gerekli';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Geçerli bir e-posta adresi girin';
                          }
                          return null;
                        }))
              ]),
              SizedBox(height: 10),
              Row(children: [Expanded(child: CustomLabelTextField(readOnly: vm.readOnly, controller: vm.addressController, label: "Adres"))])
            ]),
            SizedBox(height: 40),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Acil Durum Kişi Bilgileri", style: appState.themeData.textTheme.headlineMedium),
              SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.emergencyNameSurnameController,
                        label: "Ad Soyad",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad gerekli';
                          }
                          return null;
                        })),
                SizedBox(width: 30),
                Expanded(
                    child: CustomLabelTextField(
                        readOnly: vm.readOnly,
                        controller: vm.emergencyPhoneNumberController,
                        label: "Telefon Numarası",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Telefon numarası gerekli';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Geçerli bir telefon numarası girin';
                          }
                          return null;
                        })),
              ])
            ])
          ],
        ),
      ),
    );
  }
}
