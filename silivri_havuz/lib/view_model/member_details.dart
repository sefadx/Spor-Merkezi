import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:silivri_havuz/model/file_model.dart';
import 'package:silivri_havuz/model/health_status.dart';
import 'package:silivri_havuz/model/payment_status.dart';
import 'package:silivri_havuz/model/trainer_model.dart';
import 'package:silivri_havuz/utils/enums.dart';

import '../model/member_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';
import '../utils/extension.dart';
import 'home.dart';

class ViewModelMemberDetails extends ChangeNotifier {
  ViewModelMemberDetails({this.readOnly = false});
  ViewModelMemberDetails.fromModel({required this.memberModel, this.readOnly = true}) {
    identityController.text = memberModel.identityNumber;
    nameController.text = memberModel.name;
    surnameController.text = memberModel.surname;
    birthdateController.text = format.format(memberModel.birthDate);
    birthPlaceController.text = memberModel.birthPlace.toString();
    genderController.text = memberModel.gender.toString();
    educationLevelController.text = memberModel.educationLevel.toString();
    phoneController.text = memberModel.phoneNumber;
    emailController.text = memberModel.email;
    addressController.text = memberModel.address;
    emergencyNameSurnameController.text = memberModel.emergencyContactName;
    emergencyPhoneNumberController.text = memberModel.emergencyContactPhoneNumber;
  }

  late MemberModel memberModel;
  bool readOnly;

  final formKey = GlobalKey<FormState>();
  final TextEditingController identityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController educationLevelController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emergencyNameSurnameController = TextEditingController();
  final TextEditingController emergencyPhoneNumberController = TextEditingController();

  FilePickerResult? pickedFile;
  void pickFile() async {
    pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      File file = File(pickedFile!.files.single.path!);
      final fileSize = pickedFile!.files.single.size / (1024 * 1024);
      debugPrint("Yüklenecek dosya: ${file.path}, Boyut: ${fileSize.toStringAsFixed(2)}MB");

      // 5MB sınırı
      if (fileSize > 5 * 1024 * 1024) {
        CustomRouter.instance.pushWidget(
            child: PagePopupInfo(
              title: "Bildirim",
              informationText: "Dosya boyutu 5MB dan büyük olamaz.\nBoyut: ${fileSize.toStringAsFixed(2)}MB",
            ),
            pageConfig: ConfigPopupInfo());
        return;
      }

      FileModel model = FileModel(
          trainerModel: TrainerModel.id(id: "67c4b83e3fc862ea8697fd3d"),
          memberModel: memberModel,
          approvalDate: DateTime.now(),
          fileName: "saglik_raporu",
          reportType: ReportTypes.SaglikRaporu);

      debugPrint("Dosya yolu: ${pickedFile!.files.single.name}");
      debugPrint("Dosya yolu: ${pickedFile!.files.single.size.toString()}");
      BaseResponseModel res = await APIService<FileModel>(url: APIS.api.upload()).uploadFile(model, filePath: file.path);
      debugPrint(res.toJson().toString());
    } else {
      CustomRouter.instance.pushWidget(
          child: const PagePopupInfo(
            title: "Bildirim",
            informationText: "Dosya seçimi iptal edildi.",
          ),
          pageConfig: ConfigPopupInfo());
    }
    notifyListeners();
  }

  void pickDate(BuildContext context) async {
    DateTime date = await selectDate(context, initialDate: birthdateController.text != "" ? format.parse(birthdateController.text) : null);
    birthdateController.text = format.format(date);
    notifyListeners();
  }

  void onSave() async {
    debugPrint("onSave çalıştı.");
    if (formKey.currentState!.validate() && birthdateController.text.isNotEmpty) {
      if (await CustomRouter.instance.waitForResult(
          const PageAlertDialog(title: "Uyarı", informationText: "Üye kaydı oluşturulacaktır. Onaylıyor musunuz ?"), ConfigAlertDialog)) {
        MemberModel model = MemberModel(
            identityNumber: identityController.text,
            name: nameController.text,
            surname: surnameController.text,
            birthDate: format.parse(birthdateController.text),
            birthPlace: Cities.fromString(birthPlaceController.text),
            gender: Genders.fromString(genderController.text),
            educationLevel: EducationLevels.fromString(educationLevelController.text),
            phoneNumber: phoneController.text,
            email: emailController.text,
            address: addressController.text,
            emergencyContactName: emergencyNameSurnameController.text,
            emergencyContactPhoneNumber: emergencyPhoneNumberController.text,
            paymentStatus: PaymentStatus(text: "text"),
            healthStatus: HealthStatus(text: "text"));

        BaseResponseModel res = await APIService<MemberModel>(url: APIS.api.member())
            .post(model)
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.success) {
          ViewModelHome.instance.fetchMember();

          CustomRouter.instance.replacePushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
                afterDelay: () => CustomRouter.instance.pop(),
              ),
              pageConfig: ConfigPopupInfo());
        } else {
          CustomRouter.instance.pushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
              ),
              pageConfig: ConfigPopupInfo());
        }
      }
    } else {}
  }
}
