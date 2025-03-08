import 'package:flutter/material.dart';
import '../../utils/enums.dart';
import '../../controller/app_state.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../view_model/member_details.dart';

class FormContentMember extends StatefulWidget {
  const FormContentMember({required this.vm, this.onSave, this.onSaveText, super.key});

  final ViewModelMemberDetails vm;
  final void Function()? onSave;
  final String? onSaveText;

  @override
  State<FormContentMember> createState() => _FormContentMemberState();
}

class _FormContentMemberState extends State<FormContentMember> {
  @override
  void initState() {
    widget.vm.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.vm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Kişisel Bilgiler", style: AppState.instance.themeData.textTheme.headlineMedium),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: CustomLabelTextField(
                readOnly: widget.vm.readOnly,
                controller: widget.vm.identityController,
                label: "T.C. Kimlik No",
                //validator: validateIdentityNumber
              )),
              SizedBox(width: 30),
              Expanded(
                  child: CustomLabelTextField(
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.nameController,
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
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.surnameController,
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
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.birthdateController,
                      label: "Doğum Tarihi   gg/aa/yyyy",
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: AppState.instance.themeData.primaryColorDark,
                        ),
                        onPressed: !widget.vm.readOnly
                            ? () async {
                                widget.vm.pickDate(context);
                              }
                            : null,
                      ))),
              SizedBox(width: 30),
              Expanded(
                  child: widget.vm.readOnly
                      ? CustomLabelTextField(
                          readOnly: widget.vm.readOnly,
                          controller: widget.vm.birthPlaceController,
                          label: "Doğum Yeri",
                        )
                      : CustomDropdownList(
                          readOnly: widget.vm.readOnly,
                          value: widget.vm.birthPlaceController.text != "" ? widget.vm.birthPlaceController.text : null,
                          labelText: "Doğum Yeri",
                          list: List<String>.from(Cities.values.map((e) => e.toString())),
                          errorText: 'Doğum yeri seçilmesi gerekiyor.',
                          onChanged: (text) {
                            widget.vm.birthPlaceController.text = text!;
                          }))
            ]),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: widget.vm.readOnly
                      ? CustomLabelTextField(
                          readOnly: widget.vm.readOnly,
                          controller: widget.vm.genderController,
                          label: "Cinsiyet",
                        )
                      : CustomDropdownList(
                          readOnly: widget.vm.readOnly,
                          value: widget.vm.genderController.text != "" ? widget.vm.genderController.text : null,
                          labelText: "Cinsiyet",
                          list: List<String>.from(Genders.values.map((e) => e.toString())),
                          errorText: 'Cinsiyet seçilmesi gerekiyor.',
                          onChanged: (text) {
                            widget.vm.genderController.text = text!;
                          })),
              SizedBox(width: 30),
              Expanded(
                  child: widget.vm.readOnly
                      ? CustomLabelTextField(
                          readOnly: widget.vm.readOnly,
                          controller: widget.vm.educationLevelController,
                          label: "Eğitim Durumu",
                        )
                      : CustomDropdownList(
                          readOnly: widget.vm.readOnly,
                          value: widget.vm.educationLevelController.text != "" ? widget.vm.educationLevelController.text : null,
                          labelText: "Eğitim Durumu",
                          list: List<String>.from(EducationLevels.values.map((e) => e.toString())),
                          errorText: 'Eğitim durumunuzu seçiniz.',
                          onChanged: (text) {
                            widget.vm.educationLevelController.text = text!;
                          })),
            ]),
          ]),
          SizedBox(height: 40),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("İletişim Bilgileri", style: AppState.instance.themeData.textTheme.headlineMedium),
            SizedBox(height: 10),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                  child: CustomLabelTextField(
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.phoneController,
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
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.emailController,
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
            Row(children: [
              Expanded(child: CustomLabelTextField(readOnly: widget.vm.readOnly, controller: widget.vm.addressController, label: "Adres"))
            ])
          ]),
          SizedBox(height: 40),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Acil Durum Kişi Bilgileri", style: AppState.instance.themeData.textTheme.headlineMedium),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: CustomLabelTextField(
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.emergencyNameSurnameController,
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
                      readOnly: widget.vm.readOnly,
                      controller: widget.vm.emergencyPhoneNumberController,
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
          ]),
          SizedBox(height: 40),
          !widget.vm.readOnly
              ? Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      text: widget.onSaveText ?? "",
                      onTap: widget.onSave,
                    )),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
