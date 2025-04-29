import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/controller/app_theme.dart';
import '/navigator/custom_navigation_view.dart';
import '/navigator/ui_page.dart';
import '/pages/file_form.dart';
import '../../controller/app_state.dart';
import '../../controller/provider.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../utils/enums.dart';
import '../../utils/extension.dart';
import '../../view_model/member_details.dart';

class FormContentMember extends StatelessWidget {
  const FormContentMember({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelMemberDetails>(context);
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(AppTheme.gapmedium),
            child: Form(
                key: vm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Kişisel Bilgiler", style: appState.themeData.textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            child: CustomLabelTextField(
                          readOnly: vm.readOnly,
                          controller: vm.identityController,
                          label: "T.C. Kimlik No",
                          validator: validateTcKimlik,
                        )),
                        const SizedBox(width: AppTheme.gaplarge),
                        Expanded(
                            child: CustomLabelTextField(
                                readOnly: vm.readOnly, controller: vm.nameController, label: "Ad", validator: (value) => value == null || value.isEmpty ? 'Ad gerekli' : null)),
                        const SizedBox(width: AppTheme.gaplarge),
                        Expanded(
                            child: CustomLabelTextField(
                                readOnly: vm.readOnly,
                                controller: vm.surnameController,
                                label: "Soyad",
                                validator: (value) => value == null || value.isEmpty ? 'Soyad gerekli' : null))
                      ]),
                      const SizedBox(height: AppTheme.gapsmall),
                      Row(children: [
                        Expanded(
                            child: CustomLabelTextField(
                          readOnly: vm.readOnly,
                          controller: vm.birthdateController,
                          label: "Doğum Tarihi  (GG/AA/YYYY)",
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8), // Maksimum 8 karakter
                            DateFormatter(),
                          ],
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range, color: appState.themeData.primaryColorDark),
                            onPressed: !vm.readOnly ? () async => pickDate(context, controller: vm.birthdateController) : null,
                          ),
                          validator: validateDate,
                        )),
                        const SizedBox(width: AppTheme.gaplarge),
                        Expanded(
                            child: vm.readOnly
                                ? CustomLabelTextField(readOnly: vm.readOnly, controller: vm.birthPlaceController, label: "Doğum Yeri")
                                : CustomDropdownList(
                                    readOnly: vm.readOnly,
                                    value: vm.birthPlaceController.text != "" ? vm.birthPlaceController.text : null,
                                    labelText: "Doğum Yeri",
                                    list: List<String>.from(Cities.values.map((e) => e.toString())),
                                    errorText: 'Doğum yeri seçilmesi gerekiyor.',
                                    onChanged: (text) => vm.birthPlaceController.text = text!))
                      ]),
                      const SizedBox(height: AppTheme.gapsmall),
                      Row(
                        children: [
                          Expanded(
                              child: vm.readOnly
                                  ? CustomLabelTextField(readOnly: vm.readOnly, controller: vm.genderController, label: "Cinsiyet")
                                  : CustomDropdownList(
                                      readOnly: vm.readOnly,
                                      value: vm.genderController.text != "" ? vm.genderController.text : null,
                                      labelText: "Cinsiyet",
                                      list: List<String>.from(Genders.values.map((e) => e.toString())),
                                      errorText: 'Cinsiyet seçilmesi gerekiyor.',
                                      onChanged: (text) => vm.genderController.text = text!)),
                          const SizedBox(width: AppTheme.gaplarge),
                          Expanded(
                              child: vm.readOnly
                                  ? CustomLabelTextField(readOnly: vm.readOnly, controller: vm.educationLevelController, label: "Eğitim Durumu")
                                  : CustomDropdownList(
                                      readOnly: vm.readOnly,
                                      value: vm.educationLevelController.text != "" ? vm.educationLevelController.text : null,
                                      labelText: "Eğitim Durumu",
                                      list: List<String>.from(EducationLevels.values.map((e) => e.toString())),
                                      errorText: 'Eğitim durumunuzu seçiniz.',
                                      onChanged: (text) => vm.educationLevelController.text = text!)),
                        ],
                      )
                    ]),
                    const SizedBox(height: AppTheme.gaplarge),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("İletişim Bilgileri", style: appState.themeData.textTheme.headlineMedium),
                        const SizedBox(height: AppTheme.gapsmall),
                        Row(mainAxisSize: MainAxisSize.max, children: [
                          Expanded(child: CustomLabelTextField(readOnly: vm.readOnly, controller: vm.phoneController, label: "Telefon Numarası", validator: validatePhoneNo)),
                          const SizedBox(width: AppTheme.gaplarge),
                          Expanded(child: CustomLabelTextField(readOnly: vm.readOnly, controller: vm.emailController, label: "E-posta", validator: validateMailAddress))
                        ]),
                        const SizedBox(height: AppTheme.gapsmall),
                        CustomLabelTextField(
                            readOnly: vm.readOnly, controller: vm.addressController, label: "Adres", validator: (value) => value == null || value.isEmpty ? 'Adres gerekli' : null)
                      ],
                    ),
                    const SizedBox(height: AppTheme.gaplarge),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Acil Durum Kişi Bilgileri", style: appState.themeData.textTheme.headlineMedium),
                        const SizedBox(height: AppTheme.gapsmall),
                        Row(
                          children: [
                            Expanded(
                                child: CustomLabelTextField(
                                    readOnly: vm.readOnly,
                                    controller: vm.emergencyNameSurnameController,
                                    label: "Ad Soyad",
                                    validator: (value) => value == null || value.isEmpty ? 'Ad Soyad gerekli' : null)),
                            const SizedBox(width: AppTheme.gaplarge),
                            Expanded(
                                child: CustomLabelTextField(
                                    readOnly: vm.readOnly, controller: vm.emergencyPhoneNumberController, label: "Telefon Numarası", validator: validatePhoneNo))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: AppTheme.gapxlarge),
                    vm.readOnly
                        ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            //direction: Axis.vertical,
                            children: [
                              Row(
                                children: [
                                  Text("Sağlık Raporları", style: appState.themeData.textTheme.headlineMedium),
                                  IconButton(onPressed: () => vm.pickFile(), icon: const Icon(Icons.add)),
                                ],
                              ),
                              const SizedBox(height: AppTheme.gapsmall),
                              if (vm.listMemberFiles == null)
                                const Text("Sağlık raporu yok")
                              else if (vm.listMemberFiles!.isEmpty)
                                const Text("Sağlık raporu yok")
                              else
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: vm.listMemberFiles?.length,
                                    itemBuilder: (context, index) {
                                      final date = vm.listMemberFiles!.elementAt(index).approvalDate.toLocal();
                                      return Row(
                                        children: [
                                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                                          const SizedBox(width: AppTheme.gapmedium),
                                          Text("${vm.listMemberFiles?.elementAt(index).reportType} ${dateFormat.format(date).toString()}"),
                                          const SizedBox(width: AppTheme.gapmedium),
                                          IconButton(
                                              icon: const Icon(Icons.remove_red_eye),
                                              onPressed: () async {
                                                if (await CustomRouter.instance
                                                    .waitForResult(child: PageFileForm.readOnly(fileModel: vm.listMemberFiles!.elementAt(index)), pageConfig: ConfigPopupWidget)) {
                                                  await vm.downloadAndOpenFile(fileId: vm.listMemberFiles!.elementAt(index).fileId);
                                                } else {}
                                              })
                                        ],
                                      );
                                    })
                            ],
                          )
                        : const SizedBox()
                  ],
                ))));
  }
}
